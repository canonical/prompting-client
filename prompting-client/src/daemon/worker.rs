//! This is our main worker task for processing prompts from snapd and driving the UI.

#![cfg_attr(feature = "auto_reply", allow(unreachable_code))]
#![cfg_attr(feature = "dry-run", allow(unused_variables))]

use crate::{
    daemon::{ActionedPrompt, EnrichedPrompt, PromptUpdate, ReplyToPrompt},
    snapd_client::{Cgroup, PromptId, SnapdSocketClient, TypedUiInput},
    Result,
};
use futures::{stream::FuturesUnordered, FutureExt};
#[cfg(feature = "auto_reply")]
use std::sync::OnceLock;
use std::{
    collections::{HashMap, VecDeque},
    env,
    fmt::Debug,
    path::Path,
    process::ExitStatus,
    sync::{Arc, Mutex},
    time::Duration,
};
use tokio::{
    process::{Child, Command},
    sync::mpsc::{error::TryRecvError, UnboundedReceiver},
    time::timeout,
};
use tokio_context::context::{Context, Handle};
use tokio_stream::StreamExt;
use tracing::{debug, error, info, warn};

const RECV_TIMEOUT: Duration = Duration::from_millis(200);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
enum Recv {
    Success,
    Timeout,
    Gone,
    DeadPrompt,
    Unexpected,
    ChannelClosed,
}

#[derive(Debug)]
pub struct RefActivePrompts(Arc<Mutex<HashMap<Cgroup, ActivePrompt>>>);

pub struct ActivePrompt {
    pub(crate) typed_ui_input: TypedUiInput,
    pub(crate) enriched_prompt: EnrichedPrompt,
    pub(crate) ui_handle: Option<Handle>,
}

impl Debug for ActivePrompt {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "some active prompt")
    }
}

impl RefActivePrompts {
    #[cfg(test)]
    pub fn new(active_prompts: HashMap<Cgroup, ActivePrompt>) -> Self {
        Self(Arc::new(Mutex::new(active_prompts)))
    }

    #[cfg(test)]
    pub fn drop_prompt(&mut self, cgroup: &Cgroup) {
        let mut guard = match self.0.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };
        guard.remove(cgroup);
    }

    pub fn get(&self, cgroup: &Cgroup) -> Option<TypedUiInput> {
        let guard = match self.0.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };
        Some(guard.get(cgroup)?.typed_ui_input.clone())
    }

    pub fn get_context(&self, cgroup: &Cgroup) -> Option<Context> {
        let mut guard = match self.0.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };
        Some(guard.get_mut(cgroup)?.ui_handle.as_mut()?.spawn_ctx())
    }
}

impl Clone for RefActivePrompts {
    fn clone(&self) -> Self {
        RefActivePrompts(self.0.clone())
    }
}

pub trait DialogHandle: Debug {
    async fn wait(&mut self) -> Result<ExitStatus>;
}

#[derive(Debug)]
pub struct DialogProcess(Child);

impl DialogHandle for DialogProcess {
    async fn wait(&mut self) -> Result<ExitStatus> {
        Ok(self.0.wait().await?)
    }
}

pub trait SpawnUi: Debug {
    type Handle;
    fn spawn(&mut self, args: &[&str]) -> Result<Self::Handle>;
}

#[derive(Debug)]
pub struct FlutterUi {
    cmd: String,
}

impl SpawnUi for FlutterUi {
    type Handle = DialogProcess;
    fn spawn(&mut self, args: &[&str]) -> Result<DialogProcess> {
        Ok(DialogProcess(Command::new(&self.cmd).args(args).spawn()?))
    }
}

#[derive(Debug)]
pub struct Worker<S, R, D>
where
    S: SpawnUi,
    R: ReplyToPrompt,
    D: DialogHandle,
{
    rx_prompts: UnboundedReceiver<PromptUpdate>,
    rx_actioned_prompts: UnboundedReceiver<ActionedPrompt>,
    active_prompts: RefActivePrompts,
    dialog_processes: HashMap<Cgroup, D>,
    pending_prompts: HashMap<Cgroup, VecDeque<EnrichedPrompt>>,
    dead_prompts: Vec<PromptId>,
    recv_timeout: Duration,
    ui: S,
    client: R,
    running: bool,
}

impl Worker<FlutterUi, SnapdSocketClient, DialogProcess> {
    pub fn new(
        rx_prompts: UnboundedReceiver<PromptUpdate>,
        rx_actioned_prompts: UnboundedReceiver<ActionedPrompt>,
        client: SnapdSocketClient,
    ) -> Self {
        let cmd = {
            let cmd = if let Ok(snap) = env::var("SNAP") {
                format!("{snap}/bin/prompting_client_ui")
            } else {
                info!("SNAP env var is not setted");
                String::new()
            };

            #[cfg(feature = "dry-run")]
            let cmd = if let Ok(override_cmd) = env::var("FLUTTER_UI_OVERRIDE") {
                info!("using override command for the flutter UI: {override_cmd}");
                override_cmd
            } else {
                info!("FLUTTER_UI_OVERRIDE env var is not setted");
                String::new()
            };

            cmd
        };

        if !Path::new(&cmd).exists() {
            panic!("UI executable not found at path: '{cmd}'")
        }

        Self {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts: RefActivePrompts(Arc::new(Mutex::new(HashMap::new()))),
            dialog_processes: HashMap::new(),
            pending_prompts: HashMap::new(),
            dead_prompts: Vec::new(),
            recv_timeout: RECV_TIMEOUT,
            ui: FlutterUi { cmd },
            client,
            running: false,
        }
    }
}

impl<S, R, D> Worker<S, R, D>
where
    S: SpawnUi<Handle = D>,
    R: ReplyToPrompt,
    D: DialogHandle,
{
    pub fn read_only_active_prompt(&self) -> RefActivePrompts {
        self.active_prompts.clone()
    }

    pub async fn run(&mut self) -> Result<()> {
        self.running = true;

        while self.running {
            self.step().await?;
        }

        Ok(())
    }

    async fn pull_updates(
        rx_prompts: &mut UnboundedReceiver<PromptUpdate>,
        running: &mut bool,
    ) -> Option<Vec<PromptUpdate>> {
        let mut updates = vec![];
        // As we continue processing updates while a prompt is active, we only block once there are
        // no more incoming prompt updates.
        if rx_prompts.is_empty() {
            match rx_prompts.recv().await {
                Some(update) => updates.push(update),
                None => {
                    *running = false;
                    return None;
                }
            }
        }

        // Eagerly drain the channel of all prompts that are currently available rather than
        // pulling in lockstep with serving the prompts to the UI. This is to allow for updates
        // that drop pending prompts that we would have otherwise presented the UI for.
        loop {
            match rx_prompts.try_recv() {
                Ok(update) => updates.push(update),
                Err(TryRecvError::Empty) => break,
                Err(TryRecvError::Disconnected) => {
                    *running = false;
                    return None;
                }
            }
        }

        debug!("pulled updates: {updates:?}");

        Some(updates)
    }

    fn add_prompt(&mut self, enriched_prompt: EnrichedPrompt) {
        let cgroup = enriched_prompt.prompt.cgroup();
        if let Some(pending_prompts) = self.pending_prompts.get_mut(cgroup) {
            pending_prompts.push_back(enriched_prompt);
        } else {
            self.pending_prompts
                .insert(cgroup.clone(), VecDeque::from([enriched_prompt]));
        }
    }

    fn drop_prompt(&mut self, id: PromptId) {
        for (cgroup, pending_prompts) in self.pending_prompts.iter_mut() {
            let len = pending_prompts.len();
            pending_prompts.retain(|enriched_prompt| enriched_prompt.prompt.id() != &id);
            if pending_prompts.len() < len {
                info!(id=%id.0, cgroup=%cgroup.0, "dropping prompt as it has already been actioned");
            }
        }
        self.pending_prompts
            .retain(|_, pending_prompts| !pending_prompts.is_empty());

        let mut guard = match self.active_prompts.0.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };

        for (_, active_prompt) in guard.iter_mut() {
            if active_prompt.typed_ui_input.id() == &id {
                active_prompt.ui_handle.take();
            }
        }
    }

    fn process_update(&mut self, update: PromptUpdate) {
        debug!("processing update: {update:?}");

        match update {
            PromptUpdate::Add(enriched_prompt) => self.add_prompt(enriched_prompt),
            PromptUpdate::Drop(id) => self.drop_prompt(id),
        }
    }

    async fn process_next_pending_prompts(&mut self) -> Result<()> {
        let prompts_to_process: Vec<_> = self
            .pending_prompts
            .iter_mut()
            .filter(|(cgroup, _)| !self.dialog_processes.contains_key(cgroup))
            .filter_map(|(cgroup, pending_prompts)| {
                let enriched_prompt = match pending_prompts.pop_front() {
                    Some(ep) => ep,
                    None => return None,
                };
                if !self.running {
                    return None;
                }
                Some((cgroup.clone(), enriched_prompt))
            })
            .collect();

        for (cgroup, enriched_prompt) in prompts_to_process {
            debug!("got prompt: {enriched_prompt:?}");
            match TypedUiInput::try_from(enriched_prompt.clone()) {
                Err(error) => {
                    error!(%error, "failed to map prompt to UI input: replying with deny once");
                    let reply = enriched_prompt.prompt.clone().into_deny_once();
                    self.client
                        .reply(&enriched_prompt.prompt.id().clone(), reply)
                        .await?;
                }
                Ok(typed_ui_input) => {
                    self.update_active_prompt(&cgroup, enriched_prompt, typed_ui_input)?;
                }
            }
        }
        Ok(())
    }

    async fn wait_for_ui_reply(&mut self, cgroup: &Cgroup) -> Result<()> {
        debug!("waiting for ui reply");
        let exit_code = self
            .dialog_processes
            .remove(cgroup)
            .expect("dialog process")
            .wait()
            .await?
            .code()
            .expect("exit code");
        info!("UI exited with {exit_code}");

        let enriched_prompt = {
            let guard = match self.active_prompts.0.lock() {
                Ok(guard) => guard,
                Err(err) => err.into_inner(),
            };
            guard
                .get(cgroup)
                .as_ref()
                .expect("active prompt")
                .enriched_prompt
                .clone()
        };
        let expected_id = enriched_prompt.prompt.id().clone();

        #[cfg(feature = "auto_reply")]
        {
            static REPLY: OnceLock<String> = OnceLock::new();

            let reply = REPLY.get_or_init(|| {
                let env_var = env::var("PROMPTING_CLIENT_AUTO_REPLY")
                    .unwrap_or_else(|_| "DENY_ONCE".to_string());
                debug!("PROMPTING: auto_reply env value: {:?}", env_var);

                env_var
            });

            let reply = match reply.as_str() {
                "ALLOW_ONCE" => enriched_prompt.prompt.into_allow_once(),
                "ALLOW_FOREVER" => enriched_prompt.prompt.into_allow_forever(),
                _ => enriched_prompt.prompt.into_deny_once(),
            };
            self.client.reply(&expected_id, reply).await?;

            return Ok(());
        }

        loop {
            match self.wait_for_expected_prompt(&expected_id).await {
                Recv::DeadPrompt | Recv::Unexpected => continue,
                Recv::Success | Recv::Gone => break,
                Recv::Timeout => {
                    {
                        let guard = match self.active_prompts.0.lock() {
                            Ok(guard) => guard,
                            Err(err) => err.into_inner(),
                        };
                        // If we receive a timeout but the UI handle has been dropped already, that
                        // means we've explicitly closed the UI after receiving a 'Drop' update
                        // from snapd. We expect no reply from the UI in this case and also don't
                        // need to send a reply to snapd manually, as the prompt has already become
                        // invalid.
                        if guard
                            .get(cgroup)
                            .as_ref()
                            .expect("active prompt")
                            .ui_handle
                            .is_none()
                        {
                            debug!("timeout for cancelled prompt");
                            break;
                        }
                    };
                    debug!("timeout waiting for reply from UI - sending deny once");
                    let reply = enriched_prompt.prompt.into_deny_once();
                    self.client
                        .reply(&expected_id, reply)
                        .await
                        .inspect_err(|e| error!("could not send reply: {e:?}"))?;
                    break;
                }
                Recv::ChannelClosed => {
                    self.running = false;
                    return Ok(());
                }
            }
        }

        debug!("clearing active prompt");
        let mut guard = match self.active_prompts.0.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };
        guard.remove(cgroup);

        Ok(())
    }

    async fn wait_for_dialog_processes(dialog_processes: &mut HashMap<Cgroup, D>) -> Cgroup {
        dialog_processes
            .iter_mut()
            .map(|(cgroup, process_handle)| {
                process_handle.wait().map(move |result| {
                    result.expect("completes");
                    cgroup
                })
            })
            .collect::<FuturesUnordered<_>>()
            .next()
            .await
            .cloned()
            .expect("a cgroup")
    }

    /// The step function is the core of the worker and processes incoming prompts as follows:
    /// * If there's no currently active prompt, take the next pending prompt from the queue and
    ///   process it. That includes spawning the UI and storing the active prompt, UI process and
    ///   dialog handle.
    /// * Afterwards, concurrently wait for one of two possible events and handle the one that
    ///   happens first:
    ///   - The worker receives new updates in `rx_prompts`: Process those updates and drop the UI
    ///     handle in case the active prompt got dropped by snapd. The remaining cleanup (dropping
    ///     the active prompt from the internal state) will happen in the next `step` after the UI
    ///     terminates.
    ///   - The process for the current dialog terminates (this branch is only active if there is
    ///     an active process): In this case we wait for an answer sent by the dialog. If nothing
    ///     is received, that either means the UI crashed and a "deny once" is sent, or the UI
    ///     handle as been dropped explicitly (see previous item) and all that's left to do is
    ///     clean up the active prompt.
    async fn step(&mut self) -> Result<()> {
        debug!("step");

        self.process_next_pending_prompts().await?;

        tokio::select! {
            updates = Self::pull_updates(&mut self.rx_prompts, &mut self.running) => {
                if let Some(updates) = updates {
                    for update in updates {
                        self.process_update(update);
                    }
                }
            },
            cgroup = Self::wait_for_dialog_processes(&mut self.dialog_processes),
            if !self.dialog_processes.is_empty() => {
                self.wait_for_ui_reply(&cgroup).await?;
            }
        };

        Ok(())
    }

    fn update_active_prompt(
        &mut self,
        cgroup: &Cgroup,
        enriched_prompt: EnrichedPrompt,
        typed_ui_input: TypedUiInput,
    ) -> Result<()> {
        let mut guard = match self.active_prompts.0.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };

        let (_, ui_handle) = Context::new();
        let ui_handle = Some(ui_handle);

        debug!("updating active prompt");
        guard.insert(
            cgroup.clone(),
            ActivePrompt {
                typed_ui_input,
                enriched_prompt: enriched_prompt.clone(),
                ui_handle,
            },
        );
        drop(guard);

        debug!("spawning UI");
        let dialog_process = self.ui.spawn(&[
            enriched_prompt.prompt.snap(),
            &enriched_prompt.prompt.pid().to_string(),
            &enriched_prompt.prompt.cgroup().0,
        ])?;
        self.dialog_processes.insert(cgroup.clone(), dialog_process);

        Ok(())
    }

    async fn wait_for_expected_prompt(&mut self, expected_id: &PromptId) -> Recv {
        let pending_actioned_prompts = self.rx_actioned_prompts.len();
        info!("{pending_actioned_prompts} pending actioned prompts");
        match timeout(self.recv_timeout, self.rx_actioned_prompts.recv()).await {
            Ok(Some(ActionedPrompt::Actioned { id, others })) => {
                debug!(recv_id=%id.0, "reply sent for prompt");
                if !others.is_empty() {
                    debug!(to_drop=?others, "dropping prompts actioned by last reply");
                    for id in others {
                        self.drop_prompt(id);
                    }
                }

                if self.dead_prompts.contains(&id) {
                    warn!(id=%id.0, "reply was for a dead prompt");
                    self.dead_prompts.retain(|i| i != &id);
                    return Recv::DeadPrompt;
                }

                if &id == expected_id {
                    Recv::Success
                } else {
                    warn!(expected=%expected_id.0, seen=%id.0, "unexpected prompt reply");
                    Recv::Unexpected
                }
            }

            Ok(Some(ActionedPrompt::NotFound { id })) => {
                if self.dead_prompts.contains(&id) {
                    warn!(id=%id.0, "attempt to reply to dead prompt that is now gone");
                    self.dead_prompts.retain(|i| i != &id);
                }

                if &id == expected_id {
                    Recv::Gone
                } else {
                    warn!(expected=%expected_id.0, seen=%id.0, "unexpected prompt is now gone");
                    Recv::Unexpected
                }
            }

            Ok(None) => {
                warn!("actioned prompts channel is now closed, exiting");
                Recv::ChannelClosed
            }

            Err(_) => {
                error!(id=%expected_id.0, "timeout waiting for ack from grpc server");
                self.dead_prompts.push(expected_id.clone());
                Recv::Timeout
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::snapd_client::{
        interfaces::home::{HomeConstraints, HomeReplyConstraints},
        Action, Lifespan, Prompt, PromptReply, TypedPrompt, TypedPromptReply,
    };
    use simple_test_case::test_case;
    use std::env;
    use tokio::{
        sync::{
            mpsc::{unbounded_channel, UnboundedSender},
            oneshot,
        },
        time::sleep,
    };
    use tonic::async_trait;

    #[derive(Debug)]
    struct StubClient;

    #[async_trait]
    impl ReplyToPrompt for StubClient {
        async fn reply(
            &self,
            _id: &PromptId,
            _reply: TypedPromptReply,
        ) -> crate::Result<Vec<PromptId>> {
            panic!("stub client called")
        }
    }

    fn enriched_prompt(id: &str, cgroup: &str) -> EnrichedPrompt {
        EnrichedPrompt {
            prompt: TypedPrompt::Home(Prompt {
                id: PromptId(id.to_string()),
                timestamp: String::new(),
                snap: "test".to_string(),
                pid: 1234,
                cgroup: cgroup.into(),
                interface: "home".to_string(),
                constraints: HomeConstraints::default(),
            }),
            meta: None,
        }
    }

    fn add(id: &str, cgroup: &str) -> PromptUpdate {
        PromptUpdate::Add(enriched_prompt(id, cgroup))
    }

    fn drop_id(id: &str) -> PromptUpdate {
        PromptUpdate::Drop(PromptId(id.to_string()))
    }

    #[test_case(
        add("1", "cgroup_0"), [].into(), [("cgroup_0".into(), vec!["1"])].into();
        "add new prompt"
    )]
    #[test_case(
        add("2", "cgroup_1"), [("cgroup_0".into(), vec!["1"])].into(), [("cgroup_0".into(), vec!["1"]), ("cgroup_1".into(), vec!["2"])].into();
        "add new prompt to new queue"
    )]
    #[test_case(
        add("2", "cgroup_0"), [("cgroup_0".into(), vec!["1"])].into(), [("cgroup_0".into(), vec!["1", "2"])].into();
        "add new prompt to existing queue"
    )]
    #[test_case(
        drop_id("1"), [("cgroup_0".into(), vec!["1"])].into(), [].into();
        "drop last pending prompt"
    )]
    #[test_case(
        drop_id("1"), [("cgroup_0".into(), vec!["1", "2"])].into(), [("cgroup_0".into(), vec!["2"])].into();
        "drop with single queue"
    )]
    #[test_case(
        drop_id("1"), [("cgroup_0".into(), vec!["1"]), ("cgroup_1".into(), vec!["2"])].into(), [("cgroup_1".into(), vec!["2"])].into();
        "drop with multiple queues"
    )]
    #[test_case(drop_id("1"), [].into(), [].into(); "drop prompt not seen yet")]
    #[test]
    fn process_update(
        update: PromptUpdate,
        current_pending: HashMap<Cgroup, Vec<&str>>,
        expected_pending: HashMap<Cgroup, Vec<&str>>,
    ) {
        let (_, rx_prompts) = unbounded_channel();
        let (_, rx_actioned_prompts) = unbounded_channel();
        let pending_prompts = current_pending
            .into_iter()
            .map(|(cgroup, ids)| {
                (
                    cgroup.clone(),
                    ids.into_iter()
                        .map(|id| enriched_prompt(id, &cgroup.0))
                        .collect(),
                )
            })
            .collect();

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts: RefActivePrompts::new(HashMap::new()),
            dialog_processes: HashMap::new(),
            pending_prompts,
            dead_prompts: Vec::new(),
            recv_timeout: Duration::from_millis(100),
            ui: FlutterUi {
                cmd: "".to_string(),
            },
            client: StubClient,
            running: true,
        };

        w.process_update(update);

        let pending: HashMap<Cgroup, Vec<&str>> = w
            .pending_prompts
            .iter()
            .map(|(cgroup, prompts)| {
                (
                    cgroup.clone(),
                    prompts
                        .iter()
                        .map(|prompt| prompt.prompt.id().0.as_str())
                        .collect(),
                )
            })
            .collect();

        assert_eq!(pending, expected_pending);
    }

    #[test_case("1", "1", 10, Recv::Success, &["dead"]; "recv expected within timeout")]
    #[test_case("2", "1", 10, Recv::Unexpected, &["dead"]; "recv unexpected within timeout")]
    #[test_case("dead", "1", 10, Recv::DeadPrompt, &[]; "recv dead prompt")]
    #[test_case("1", "1", 200, Recv::Timeout, &["dead", "1"]; "recv expected after timeout")]
    #[tokio::test]
    async fn wait_for_expected_prompt(
        sent_id: &str,
        expected_id: &str,
        sleep_ms: u64,
        expected_recv: Recv,
        expected_dead_prompts: &[&str],
    ) {
        let (_, rx_prompts) = unbounded_channel();
        let (tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts: RefActivePrompts::new(HashMap::new()),
            dialog_processes: HashMap::new(),
            pending_prompts: HashMap::new(),
            dead_prompts: vec![PromptId("dead".to_string())],
            recv_timeout: Duration::from_millis(100),
            ui: FlutterUi {
                cmd: "".to_string(),
            },
            client: StubClient,
            running: true,
        };

        tokio::spawn(async move {
            sleep(Duration::from_millis(sleep_ms)).await;
            let _ = tx_actioned_prompts.send(ActionedPrompt::Actioned {
                id: PromptId(sent_id.to_string()),
                others: vec![PromptId("drop-me".to_string())],
            });
        });

        let recv = w
            .wait_for_expected_prompt(&PromptId(expected_id.to_string()))
            .await;

        assert_eq!(recv, expected_recv);
        assert_eq!(
            w.dead_prompts,
            Vec::from_iter(
                expected_dead_prompts
                    .iter()
                    .map(|id| PromptId(id.to_string()))
            )
        );
    }

    #[test_case("1", "1", Recv::Gone, &["dead"]; "gone for expected prompt")]
    #[test_case("2", "1", Recv::Unexpected, &["dead"]; "gone for unexpected prompt")]
    #[test_case("dead", "dead", Recv::Gone, &[]; "gone for expected dead prompt")]
    #[test_case("dead", "1", Recv::Unexpected, &[]; "gone for unexpected dead prompt")]
    #[tokio::test]
    async fn wait_for_expected_prompt_gone(
        sent_id: &str,
        expected_id: &str,
        expected_recv: Recv,
        expected_dead_prompts: &[&str],
    ) {
        let (_, rx_prompts) = unbounded_channel();
        let (tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts: RefActivePrompts::new(HashMap::new()),
            dialog_processes: HashMap::new(),
            pending_prompts: HashMap::new(),
            dead_prompts: vec![PromptId("dead".to_string())],
            recv_timeout: Duration::from_millis(100),
            ui: FlutterUi {
                cmd: "".to_string(),
            },
            client: StubClient,
            running: false,
        };

        let _ = tx_actioned_prompts.send(ActionedPrompt::NotFound {
            id: PromptId(sent_id.to_string()),
        });

        let recv = w
            .wait_for_expected_prompt(&PromptId(expected_id.to_string()))
            .await;

        assert_eq!(recv, expected_recv);
        assert_eq!(
            w.dead_prompts,
            Vec::from_iter(
                expected_dead_prompts
                    .iter()
                    .map(|id| PromptId(id.to_string()))
            )
        );
    }

    #[tokio::test]
    async fn wait_for_expected_prompt_closed_channel() {
        let (_, rx_prompts) = unbounded_channel();
        let (tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts: RefActivePrompts::new(HashMap::new()),
            dialog_processes: HashMap::new(),
            pending_prompts: HashMap::new(),
            dead_prompts: vec![PromptId("dead".to_string())],
            recv_timeout: Duration::from_millis(100),
            ui: FlutterUi {
                cmd: "".to_string(),
            },
            client: StubClient,
            running: false,
        };

        drop(tx_actioned_prompts);
        let recv = w.wait_for_expected_prompt(&PromptId("1".to_string())).await;

        assert_eq!(recv, Recv::ChannelClosed);
    }

    #[derive(Debug, Clone, Copy)]
    struct Reply {
        active_prompt_id: &'static str,
        sleep_ms: u64,
        id: &'static str,
        drop: &'static [&'static str],
    }

    fn reply(
        active_prompt_id: &'static str,
        sleep_ms: u64,
        id: &'static str,
        drop: &'static [&'static str],
    ) -> Reply {
        Reply {
            active_prompt_id,
            sleep_ms,
            id,
            drop,
        }
    }

    #[derive(Debug)]
    struct TestUi {
        replies: HashMap<Cgroup, Vec<Reply>>,
        tx: UnboundedSender<ActionedPrompt>,
        active_prompts: RefActivePrompts,
        tx_done: Option<oneshot::Sender<()>>,
    }

    impl SpawnUi for TestUi {
        type Handle = TestDialogHandle;
        fn spawn(&mut self, args: &[&str]) -> Result<TestDialogHandle> {
            debug!("spawning test ui");
            let cgroup: Cgroup = (*args.get(2).expect("a pid")).into();
            let reply = self
                .replies
                .get_mut(&cgroup)
                .map(|replies| replies.remove(0));
            self.replies.retain(|_, replies| !replies.is_empty());
            let tx = self.tx.clone();
            let active_prompt = self.active_prompts.clone();
            let reply_sent = false;
            let tx_done = self
                .replies
                .is_empty()
                .then(|| self.tx_done.take())
                .flatten();
            let context = self
                .active_prompts
                .get_context(&cgroup)
                .expect("to get a context");

            Ok(TestDialogHandle {
                reply,
                tx,
                active_prompts: active_prompt,
                context,
                closed: reply_sent,
                tx_done,
                cgroup,
            })
        }
    }

    struct TestDialogHandle {
        reply: Option<Reply>,
        tx: UnboundedSender<ActionedPrompt>,
        active_prompts: RefActivePrompts,
        context: Context,
        closed: bool,
        tx_done: Option<oneshot::Sender<()>>,
        cgroup: Cgroup,
    }

    impl Debug for TestDialogHandle {
        fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
            write!(f, "TestDialogHandle")
        }
    }

    impl DialogHandle for TestDialogHandle {
        async fn wait(&mut self) -> Result<ExitStatus> {
            debug!("test dialog handle wait");

            if self.closed {
                debug!("dialog already closed");
                return Ok(ExitStatus::default());
            }

            let active_prompt = &self
                .active_prompts
                .get(&self.cgroup)
                .expect("active prompt");
            if let Some(reply) = self.reply {
                assert_eq!(
                    reply.active_prompt_id,
                    active_prompt.id().0,
                    "incorrect active prompt"
                );
            }

            tokio::select! {
                _ = self.context.done() => {
                    debug!("test UI got closed before sending a reply");
                },
                _ = sleep(Duration::from_millis(self.reply.map(|r|r.sleep_ms).unwrap_or(u64::MAX))),
                if self.reply.is_some() => {
                    let reply = self.reply.expect("a reply");
                    let _ = self.tx.send(ActionedPrompt::Actioned {
                        id: PromptId(reply.id.to_string()),
                        others: reply
                            .drop
                            .iter()
                            .map(|id| PromptId(id.to_string()))
                            .collect(),
                    });


                },
            };

            if let Some(tx_done) = self.tx_done.take() {
                tx_done.send(()).expect("to send");
            }
            self.closed = true;

            Ok(ExitStatus::default())
        }
    }

    #[test_case(vec![], [].into(); "channel close without prompts")]
    #[test_case(
        vec![add("1", "cgroup_0")], [("cgroup_0".into(), vec![reply("1", 10, "1", &[])])].into();
        "single"
    )]
    #[test_case(
        vec![add("1", "cgroup_0"), add("2", "cgroup_1")],
        [
            ("cgroup_0".into(), vec![reply("1", 10, "1", &[])]),
            ("cgroup_1".into(), vec![reply("2", 10, "2", &[])])
        ].into();
        "single in parallel"
    )]
    #[test_case(
        vec![add("1", "cgroup_0"), add("2", "cgroup_0"), add("3", "cgroup_0")],
        [("cgroup_0".into(), vec![reply("1", 10, "1", &[]), reply("2", 10, "2", &[]), reply("3", 10, "3", &[])])].into();
        "multiple"
    )]
    #[test_case(
        vec![add("1", "cgroup_0"), add("2", "cgroup_1"), add("3", "cgroup_0"), add("4", "cgroup_1"), add("5", "cgroup_0")],
        [
            ("cgroup_0".into(), vec![reply("1", 10, "1", &[]), reply("3", 10, "3", &[]), reply("5", 10, "5", &[])]),
            ("cgroup_1".into(), vec![reply("2", 10, "2", &[]), reply("4", 10, "4", &[])])
        ].into();
        "multiple in parallel"
    )]
    #[test_case(
        vec![add("1", "cgroup_0"), add("2", "cgroup_0"), add("3", "cgroup_0")],
        [("cgroup_0".into(), vec![reply("1", 10, "1", &["2"]), reply("3", 10, "3", &[])])].into();
        "first reply actions second prompt as well"
    )]
    #[test_case(
        vec![add("1", "cgroup_0"), add("2", "cgroup_1"), add("3", "cgroup_0")],
        [("cgroup_0".into(), vec![reply("1", 10, "1", &["2"]), reply("3", 10, "3", &[])])].into();
        "first reply actions parallel prompt"
    )]
    #[test_case(
        vec![add("1", "cgroup_0"), add("2", "cgroup_0")],
        [("cgroup_0".into(), vec![reply("1", 200, "1", &[]), reply("2", 50, "2", &[])])].into();
        "delayed reply skips"
    )]
    #[test_case(
        vec![add("1", "cgroup_0"), add("2", "cgroup_0"), add("3", "cgroup_0"), drop_id("2"), add("4", "cgroup_0")],
        [(
            "cgroup_0".into(),
            vec![reply("1", 10, "1", &[]), reply("3", 10, "3", &[]), reply("4", 10, "4", &[])]
        )].into();
        "explicit drop of previous prompt"
    )]
    #[tokio::test]
    async fn sequence(updates: Vec<PromptUpdate>, replies: HashMap<Cgroup, Vec<Reply>>) {
        let (tx_prompts, rx_prompts) = unbounded_channel();
        let (tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();
        let (tx_done, rx_done) = oneshot::channel();
        let active_prompts = RefActivePrompts::new(HashMap::new());
        let ui = TestUi {
            replies,
            tx: tx_actioned_prompts,
            active_prompts: active_prompts.clone(),
            tx_done: Some(tx_done),
        };

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts,
            dialog_processes: HashMap::new(),
            pending_prompts: HashMap::new(),
            dead_prompts: vec![],
            recv_timeout: Duration::from_millis(100),
            ui,
            client: StubClient,
            running: true,
        };

        // We need this env var set to be able to generate the appropriate UI options
        // for the home interface
        env::set_var("SNAP_REAL_HOME", "/home/ubuntu");

        for update in updates.clone() {
            tx_prompts.send(update).expect("to send an update");
        }

        let handle = tokio::spawn(async move {
            w.run().await.unwrap();
            assert!(!w.running, "drop(tx_prompts) should shut down the worker");
        });

        // wait for the Test UI to signal that all prompts have been handled
        if !updates.is_empty() {
            rx_done.await.expect("done");
        }

        // drop the channel to stop the worker
        drop(tx_prompts);
        handle.await.expect("worker shuts down");
    }

    #[derive(Debug)]
    struct StubUi;

    impl SpawnUi for StubUi {
        type Handle = StubDialogHandle;
        fn spawn(&mut self, _: &[&str]) -> Result<StubDialogHandle> {
            Ok(StubDialogHandle)
        }
    }

    #[derive(Debug)]
    struct StubDialogHandle;

    impl DialogHandle for StubDialogHandle {
        async fn wait(&mut self) -> Result<ExitStatus> {
            Ok(ExitStatus::default())
        }
    }

    #[derive(Debug, Default)]
    struct AckClient {
        seen: Arc<Mutex<Vec<(PromptId, TypedPromptReply)>>>,
    }

    #[async_trait]
    impl ReplyToPrompt for AckClient {
        async fn reply(
            &self,
            id: &PromptId,
            reply: TypedPromptReply,
        ) -> crate::Result<Vec<PromptId>> {
            self.seen.lock().unwrap().push((id.clone(), reply));

            Ok(Vec::new())
        }
    }

    #[tokio::test]
    async fn timeout_waiting_for_reply_denies_once() {
        // We need to keep the sender sides of these channels from dropping so that the channels
        // remain open. Without this calls to recv() immediately returns None.
        let (_tx_prompts, rx_prompts) = unbounded_channel();
        let (_tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();
        let active_prompts = RefActivePrompts::new(HashMap::new());
        let pending_prompts = HashMap::from([(
            "cgroup_0".into(),
            vec![enriched_prompt("1", "cgroup_0")].into(),
        )]);

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts,
            dialog_processes: HashMap::new(),
            pending_prompts,
            dead_prompts: vec![],
            recv_timeout: Duration::from_millis(100),
            ui: StubUi,
            client: AckClient::default(),
            running: true,
        };

        // We need this env var set to be able to generate the appropriate UI options
        // for the home interface
        env::set_var("SNAP_REAL_HOME", "/home/ubuntu");
        w.step().await.unwrap();

        // Strip off the surrounding Arc and Mutex
        let replies_seen = Arc::into_inner(w.client.seen)
            .unwrap()
            .into_inner()
            .unwrap();

        assert_eq!(
            replies_seen,
            vec![(
                PromptId("1".to_string()),
                TypedPromptReply::Home(PromptReply {
                    action: Action::Deny,
                    lifespan: Lifespan::Single,
                    duration: None,
                    constraints: HomeReplyConstraints::default(),
                })
            )]
        );
    }

    #[tokio::test]
    async fn cancel_active_prompt() {
        let (tx_prompts, rx_prompts) = unbounded_channel();
        let (tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();
        let (tx_done, rx_done) = oneshot::channel();
        let id = "testId";
        let active_prompts = RefActivePrompts::new(HashMap::new());
        let ui = TestUi {
            replies: HashMap::new(),
            tx: tx_actioned_prompts,
            active_prompts: active_prompts.clone(),
            tx_done: Some(tx_done),
        };

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompts,
            dialog_processes: HashMap::new(),
            pending_prompts: HashMap::new(),
            dead_prompts: vec![],
            recv_timeout: Duration::from_millis(100),
            ui,
            client: StubClient,
            running: true,
        };

        // We need this env var set to be able to generate the appropriate UI options
        // for the home interface
        env::set_var("SNAP_REAL_HOME", "/home/ubuntu");

        tx_prompts
            .send(add(id, "cgroup_0"))
            .expect("to send update");
        w.step().await.expect("step");

        tx_prompts.send(drop_id(id)).expect("to send update");

        let handle = tokio::spawn(async move {
            w.run().await.expect("run");
            assert!(w.active_prompts.get(&"cgroup_0".into()).is_none());
        });

        rx_done.await.expect("done");
        drop(tx_prompts);

        handle.await.expect("worker finishes");
    }
}
