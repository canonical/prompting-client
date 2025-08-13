//! The poll loop for pulling prompt details from snapd
//!
//! The poll loop is responsible for handling out long polling on the notices API and then pulling
//! all of the required data we need from snapd in order to be able to serve the prompt UI. The
//! enriched prompts themselves are simply passed off on a channel for downstream consumption and
//! mapping into the data required for the prompt UI.
use crate::{
    daemon::{EnrichedPrompt, PromptUpdate},
    exit_with,
    snapd_client::{PromptId, PromptNotice, SnapMeta, SnapdSocketClient, TypedPrompt},
    Error, ExitStatus,
};
use cached::proc_macro::cached;
use hyper::StatusCode;
use std::time::Duration;
use tokio::{sync::mpsc::UnboundedSender, time::sleep};
use tracing::{debug, error, info, warn};

const MAX_POLL_RETRIES: usize = 3;
const RETRY_SLEEP_DURATION: Duration = Duration::from_millis(200);

#[cached(
    time = 3600,  // seconds
    option = true,
    sync_writes = true,
    key = "String",
    convert = r#"{ String::from(snap) }"#
)]
async fn get_snap_meta(client: &SnapdSocketClient, snap: &str) -> Option<SnapMeta> {
    client.snap_metadata(snap).await
}

#[derive(Debug, Clone)]
pub struct PollLoop {
    client: SnapdSocketClient,
    tx: UnboundedSender<PromptUpdate>,
    running: bool,
    skip_outstanding_prompts: bool,
}

impl PollLoop {
    pub fn new(client: SnapdSocketClient, tx: UnboundedSender<PromptUpdate>) -> Self {
        Self {
            client,
            tx,
            running: true,
            skip_outstanding_prompts: false,
        }
    }

    pub fn skip_outstanding_prompts(&mut self) {
        self.skip_outstanding_prompts = true;
    }

    /// Run our poll loop for prompting notices from snapd (runs as a top level task).
    ///
    /// This first checks for any outstanding (unactioned) prompts on the system for the user
    /// we are running under and processes them before dropping into long-polling for notices.
    /// This task is responsible for pulling prompt details and snap meta-data from snapd but
    /// does not directly process the prompts themselves.
    pub async fn run(mut self) {
        if !self.skip_outstanding_prompts {
            self.handle_outstanding_prompts().await;
        }

        let mut retries = 0;

        while self.running {
            debug!("polling for notices");
            let notices = match self.client.pending_prompt_notices().await {
                Ok(notices) => notices,

                Err(Error::SnapdError {
                    status: StatusCode::FORBIDDEN,
                    ..
                }) => {
                    // If we're now getting permission denied after initially starting cleanly
                    // then we trigger a restart with snapd so that our startup checks can run
                    // again and we avoid spinning if snapd is now reporting that prompting is not
                    // enabled / supported.
                    exit_with(ExitStatus::PermissionDenied);
                }

                Err(error) if retries < MAX_POLL_RETRIES => {
                    error!(%error, "unable to pull prompt ids: retrying");
                    sleep(RETRY_SLEEP_DURATION).await;
                    retries += 1;
                    continue;
                }

                Err(error) => {
                    error!(%error, "retries exceeded trying to establish notices long poll: exiting");
                    exit_with(ExitStatus::LongPollFail);
                }
            };

            retries = 0;
            debug!(?notices, "processing notices");
            for notice in notices {
                match notice {
                    PromptNotice::Update(id) => self.pull_and_process_prompt(id).await,
                    PromptNotice::Resolved(id) => self.send_update(PromptUpdate::Drop(id)),
                }
            }
        }
    }

    fn send_update(&mut self, update: PromptUpdate) {
        if let Err(error) = self.tx.send(update) {
            warn!(%error, "receiver channel for enriched prompts has been dropped. Exiting.");
            self.running = false;
        }
    }

    async fn pull_and_process_prompt(&mut self, id: PromptId) {
        debug!(?id, "pulling prompt details from snapd");
        let prompt = match self.client.prompt_details(&id).await {
            Ok(p) => p,

            Err(Error::SnapdError { status, .. }) if status == StatusCode::NOT_FOUND => {
                self.send_update(PromptUpdate::Drop(id));
                return;
            }

            Err(e) => {
                warn!(%e, "unable to pull prompt");
                return;
            }
        };

        debug!("prompt details: {prompt:?}");

        self.process_prompt(prompt).await;
    }

    async fn process_prompt(&mut self, prompt: TypedPrompt) {
        let meta = get_snap_meta(&self.client, prompt.snap()).await;
        self.send_update(PromptUpdate::Add(EnrichedPrompt { prompt, meta }));
    }

    /// Catch up on all pending prompts before dropping into polling the notices API
    async fn handle_outstanding_prompts(&mut self) {
        info!("checking for pending prompts");
        let pending = match self.client.all_pending_prompt_details().await {
            Err(error) => {
                error!(%error, "unable to pull pending prompts");
                return;
            }
            Ok(pending) if pending.is_empty() => {
                info!("no currently pending prompts");
                return;
            }
            Ok(pending) => pending,
        };

        let n_prompts = pending.len();
        info!(%n_prompts, "processing {n_prompts} pending prompts");
        let mut seen = Vec::with_capacity(pending.len());
        for prompt in pending {
            seen.push(prompt.id().clone());
            self.process_prompt(prompt).await;
        }

        // The timestamps we get back from the prompts API are not semantically compatible with
        // the ones that we need to provide for the notices API, so we deliberately set up an
        // overlap between pulling all pending prompts first before pulling pending prompt IDs
        // and updating our internal `after` timestamp.
        let notices = match self.client.pending_prompt_notices().await {
            Ok(notices) => notices,
            Err(error) => {
                error!(%error, "unable to pull pending prompt ids");
                return;
            }
        };

        for notice in notices {
            match notice {
                PromptNotice::Update(id) if !seen.contains(&id) => {
                    self.pull_and_process_prompt(id).await
                }

                _ => (),
            };
        }
    }
}
