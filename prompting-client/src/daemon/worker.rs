//! This is our main worker task for processing prompts from snapd and driving the UI.
use crate::{
    daemon::{ActionedPrompt, EnrichedPrompt, PromptUpdate, ReplyToPrompt},
    snapd_client::{PromptId, SnapdSocketClient, TypedUiInput},
    Result,
};
use std::{
    collections::VecDeque,
    env,
    sync::{Arc, Mutex},
    time::Duration,
};
use tokio::{
    process::Command,
    sync::mpsc::{error::TryRecvError, UnboundedReceiver},
    time::timeout,
};
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
pub struct ReadOnlyActivePrompt {
    active_prompt: Arc<Mutex<Option<TypedUiInput>>>,
}

impl ReadOnlyActivePrompt {
    #[cfg(test)]
    pub fn new(ui_input: Option<TypedUiInput>) -> Self {
        Self {
            active_prompt: Arc::new(Mutex::new(ui_input)),
        }
    }

    pub fn get(&self) -> Option<TypedUiInput> {
        let guard = match self.active_prompt.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };
        guard.clone()
    }
}

pub trait SpawnUi {
    async fn spawn(&mut self) -> Result<()>;
}

pub struct FlutterUi {
    cmd: String,
}

impl SpawnUi for FlutterUi {
    async fn spawn(&mut self) -> Result<()> {
        Command::new(&self.cmd).spawn()?.wait().await?;

        Ok(())
    }
}

#[derive(Debug)]
pub struct Worker<S, R>
where
    S: SpawnUi,
    R: ReplyToPrompt,
{
    rx_prompts: UnboundedReceiver<PromptUpdate>,
    rx_actioned_prompts: UnboundedReceiver<ActionedPrompt>,
    active_prompt: Arc<Mutex<Option<TypedUiInput>>>,
    pending_prompts: VecDeque<EnrichedPrompt>,
    dead_prompts: Vec<PromptId>,
    recv_timeout: Duration,
    ui: S,
    client: R,
    running: bool,
}

impl Worker<FlutterUi, SnapdSocketClient> {
    pub fn new(
        rx_prompts: UnboundedReceiver<PromptUpdate>,
        rx_actioned_prompts: UnboundedReceiver<ActionedPrompt>,
        client: SnapdSocketClient,
    ) -> Self {
        let snap = env::var("SNAP").expect("SNAP env var to be set");
        let cmd = format!("{snap}/bin/prompting_client_ui");

        Self {
            rx_prompts,
            rx_actioned_prompts,
            active_prompt: Arc::new(Mutex::new(None)),
            pending_prompts: VecDeque::new(),
            dead_prompts: Vec::new(),
            recv_timeout: RECV_TIMEOUT,
            ui: FlutterUi { cmd },
            client,
            running: false,
        }
    }
}

impl<S, R> Worker<S, R>
where
    S: SpawnUi,
    R: ReplyToPrompt,
{
    pub fn read_only_active_prompt(&self) -> ReadOnlyActivePrompt {
        ReadOnlyActivePrompt {
            active_prompt: self.active_prompt.clone(),
        }
    }

    pub async fn run(&mut self) -> Result<()> {
        self.running = true;

        while self.running {
            self.step().await?;
        }

        Ok(())
    }

    async fn pull_updates(&mut self) {
        // If there are currently no prompts pending in the channel and nothing in our internal
        // pending_prompts buffer then we block until at least one prompt arrives rather than busy
        // looping with try_recv below.
        if self.rx_prompts.is_empty() && self.pending_prompts.is_empty() {
            match self.rx_prompts.recv().await {
                Some(update) => self.process_update(update),
                None => {
                    self.running = false; // channel now closed
                    return;
                }
            }
        }

        // Eagerly drain the channel of all prompts that are currently available rather than
        // pulling in lockstep with serving the prompts to the UI. This is to allow for updates
        // that drop pending prompts that we would have otherwise presented the UI for.
        loop {
            match self.rx_prompts.try_recv() {
                Ok(update) => self.process_update(update),
                Err(TryRecvError::Empty) => return,
                Err(TryRecvError::Disconnected) => {
                    self.running = false;
                    return;
                }
            }
        }
    }

    fn drop_prompt(&mut self, id: PromptId) {
        let len = self.pending_prompts.len();
        self.pending_prompts.retain(|ep| ep.prompt.id() != &id);
        if self.pending_prompts.len() < len {
            info!(id=%id.0, "dropping prompt as it has already been actioned");
        }
    }

    fn process_update(&mut self, update: PromptUpdate) {
        match update {
            PromptUpdate::Add(ep) => self.pending_prompts.push_back(ep),
            PromptUpdate::Drop(id) => self.drop_prompt(id),
        }
    }

    async fn step(&mut self) -> Result<()> {
        self.pull_updates().await;

        let ep = match self.pending_prompts.pop_front() {
            Some(ep) if self.running => ep,
            _ => return Ok(()),
        };

        debug!("got prompt: {ep:?}");

        let expected_id = ep.prompt.id().clone();
        let prompt = ep.prompt.clone();

        debug!("updating active prompt");
        if let Err(error) = self.update_active_prompt(ep) {
            error!(%error, "failed to map prompt to UI input: replying with deny once");
            let reply = prompt.into_deny_once();
            self.client.reply(&expected_id, reply).await?;
            return Ok(());
        }

        // FIXME: the UI closing without replying or actioning multiple prompts gets tricky (when can we spawn the next UI?)
        debug!("spawning UI");
        self.ui.spawn().await?;

        loop {
            match self.wait_for_expected_prompt(&expected_id).await {
                Recv::DeadPrompt | Recv::Unexpected => continue,
                Recv::Success | Recv::Gone => break,
                Recv::Timeout => {
                    let reply = prompt.into_deny_once();
                    self.client.reply(&expected_id, reply).await?;
                    break;
                }
                Recv::ChannelClosed => {
                    self.running = false;
                    return Ok(());
                }
            }
        }

        debug!("clearing active prompt");
        self.active_prompt
            .lock()
            .expect("grpc server panicked")
            .take();

        Ok(())
    }

    fn update_active_prompt(&mut self, ep: EnrichedPrompt) -> Result<()> {
        let input = TypedUiInput::try_from(ep)?;
        let mut guard = match self.active_prompt.lock() {
            Ok(guard) => guard,
            Err(err) => err.into_inner(),
        };
        guard.replace(input);

        Ok(())
    }

    async fn wait_for_expected_prompt(&mut self, expected_id: &PromptId) -> Recv {
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
    use std::{
        env,
        sync::{Arc, Mutex},
    };
    use tokio::{
        sync::mpsc::{unbounded_channel, UnboundedSender},
        time::sleep,
    };
    use tonic::async_trait;

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

    fn ep(id: &str) -> EnrichedPrompt {
        EnrichedPrompt {
            prompt: TypedPrompt::Home(Prompt {
                id: PromptId(id.to_string()),
                timestamp: String::new(),
                snap: "test".to_string(),
                pid: 1234,
                interface: "home".to_string(),
                constraints: HomeConstraints::default(),
            }),
            meta: None,
        }
    }

    fn add(id: &str) -> PromptUpdate {
        PromptUpdate::Add(ep(id))
    }

    fn drop_id(id: &str) -> PromptUpdate {
        PromptUpdate::Drop(PromptId(id.to_string()))
    }

    #[tokio::test]
    async fn pull_updates_with_pending_prompts_doesnt_block() {
        // We need to keep the sender sides of these channels from dropping so that the channels
        // remain open. Without this the call to self.rx_prompts.recv() immediately returns None.
        let (_tx_prompts, rx_prompts) = unbounded_channel();
        let (_tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompt: Arc::new(Mutex::new(None)),
            pending_prompts: [ep("1")].into_iter().collect(),
            dead_prompts: Vec::new(),
            recv_timeout: Duration::from_millis(100),
            ui: FlutterUi {
                cmd: "".to_string(),
            },
            client: StubClient,
            running: true,
        };

        let res = timeout(Duration::from_millis(1000), w.pull_updates()).await;

        assert!(w.running, "worker no longer runnning");
        assert!(
            res.is_ok(),
            "we blocked waiting for an update from the poll loop"
        );
    }

    #[test_case(add("1"), &[], &["1"]; "add new prompt")]
    #[test_case(drop_id("1"), &["1"], &[]; "drop for pending prompt")]
    #[test_case(drop_id("1"), &[], &[]; "drop prompt not seen yet")]
    #[test]
    fn process_update(update: PromptUpdate, current_pending: &[&str], expected_pending: &[&str]) {
        let (_, rx_prompts) = unbounded_channel();
        let (_, rx_actioned_prompts) = unbounded_channel();
        let pending_prompts = current_pending.iter().map(|id| ep(id)).collect();

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompt: Arc::new(Mutex::new(None)),
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

        let pending: Vec<&str> = w
            .pending_prompts
            .iter()
            .map(|ep| ep.prompt.id().0.as_str())
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
            active_prompt: Arc::new(Mutex::new(None)),
            pending_prompts: VecDeque::new(),
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
            active_prompt: Arc::new(Mutex::new(None)),
            pending_prompts: VecDeque::new(),
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
            active_prompt: Arc::new(Mutex::new(None)),
            pending_prompts: VecDeque::new(),
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
        active_prompt: &'static str,
        sleep_ms: u64,
        id: &'static str,
        drop: &'static [&'static str],
    }

    fn rep(
        active_prompt: &'static str,
        sleep_ms: u64,
        id: &'static str,
        drop: &'static [&'static str],
    ) -> Reply {
        Reply {
            active_prompt,
            sleep_ms,
            id,
            drop,
        }
    }

    struct TestUi {
        replies: Vec<Reply>,
        tx: UnboundedSender<ActionedPrompt>,
        active_prompt: ReadOnlyActivePrompt,
    }

    impl SpawnUi for TestUi {
        async fn spawn(&mut self) -> Result<()> {
            let Reply {
                active_prompt,
                sleep_ms,
                id,
                drop,
            } = self.replies.remove(0);

            let ap = &self.active_prompt.get().expect("active prompt");
            assert_eq!(active_prompt, ap.id().0, "incorrect active prompt");

            let tx = self.tx.clone();

            // Send from a task so the Worker sees the UI "exit" and starts waiting for the reply
            tokio::spawn(async move {
                sleep(Duration::from_millis(sleep_ms)).await;
                let _ = tx.send(ActionedPrompt::Actioned {
                    id: PromptId(id.to_string()),
                    others: drop.iter().map(|id| PromptId(id.to_string())).collect(),
                });
            });

            Ok(())
        }
    }

    #[test_case(vec![], &[]; "channel close without prompts")]
    #[test_case(vec![add("1")], &[rep("1", 10, "1", &[])]; "single")]
    #[test_case(
        vec![add("1"), add("2"), add("3")],
        &[rep("1", 10, "1", &[]), rep("2", 10, "2", &[]), rep("3", 10, "3", &[])];
        "multiple"
    )]
    #[test_case(
        vec![add("1"), add("2"), add("3")],
        &[rep("1", 10, "1", &["2"]), rep("3", 10, "3", &[])];
        "first reply actions second prompt as well"
    )]
    #[test_case(
        vec![add("1"), add("2")],
        &[rep("1", 200, "1", &[]), rep("2", 50, "2", &[])];
        "delayed reply skips"
    )]
    #[test_case(
        vec![add("1"), add("2"), add("3"), drop_id("2"), add("4")],
        &[rep("1", 10, "1", &[]), rep("3", 10, "3", &[]), rep("4", 10, "4", &[])];
        "explicit drop of previous prompt"
    )]
    #[tokio::test]
    async fn sequence(updates: Vec<PromptUpdate>, replies: &[Reply]) {
        let (tx_prompts, rx_prompts) = unbounded_channel();
        let (tx_actioned_prompts, rx_actioned_prompts) = unbounded_channel();
        let active_prompt = Arc::new(Mutex::new(None));
        let ui = TestUi {
            replies: replies.to_vec(),
            tx: tx_actioned_prompts,
            active_prompt: ReadOnlyActivePrompt {
                active_prompt: active_prompt.clone(),
            },
        };

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompt,
            pending_prompts: VecDeque::new(),
            dead_prompts: vec![],
            recv_timeout: Duration::from_millis(100),
            ui,
            client: StubClient,
            running: true,
        };

        // We need this env var set to be able to generate the appropriate UI options
        // for the home interface
        env::set_var("SNAP_REAL_HOME", "/home/ubuntu");

        for update in updates {
            let _ = tx_prompts.send(update);
        }

        drop(tx_prompts);
        w.step().await.unwrap();
        assert!(!w.running, "drop(tx_prompts) should shut down the worker");
    }

    struct StubUi;

    impl SpawnUi for StubUi {
        async fn spawn(&mut self) -> Result<()> {
            Ok(())
        }
    }

    #[derive(Default)]
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
        let active_prompt = Arc::new(Mutex::new(None));

        let mut w = Worker {
            rx_prompts,
            rx_actioned_prompts,
            active_prompt,
            pending_prompts: [ep("1")].into_iter().collect(),
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
}
