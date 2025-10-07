use crate::{
    exit_with,
    snapd_client::{PromptId, SnapMeta, SnapdSocketClient, TypedPrompt, TypedPromptReply},
    Result, SOCKET_ENV_VAR,
};
use serde::Serialize;
use std::{env, fmt::Debug, fs, sync::Arc};
use tokio::{sync::mpsc::unbounded_channel, task::JoinSet};
use tokio_stream::wrappers::UnixListenerStream;
use tonic::{async_trait, transport::Server};
use tracing::{debug, error};
use tracing_subscriber::{reload::Handle, EnvFilter};

mod poll;
mod server;
mod worker;

pub use poll::PollLoop;
use server::new_server_and_listener;
use worker::Worker;

#[async_trait]
pub trait ReplyToPrompt: Debug + Send + Sync + 'static {
    async fn reply(&self, id: &PromptId, reply: TypedPromptReply) -> crate::Result<Vec<PromptId>>;
}

#[async_trait]
impl ReplyToPrompt for SnapdSocketClient {
    async fn reply(&self, id: &PromptId, reply: TypedPromptReply) -> crate::Result<Vec<PromptId>> {
        self.reply_to_prompt(id, reply).await
    }
}

// Poll loop -> worker
#[derive(Debug, Clone, Serialize)]
pub struct EnrichedPrompt {
    pub(crate) prompt: TypedPrompt,
    pub(crate) meta: Option<SnapMeta>,
}

#[allow(clippy::large_enum_variant)]
#[derive(Debug, Clone, Serialize)]
pub enum PromptUpdate {
    Add(EnrichedPrompt),
    Drop(PromptId),
}

// Server -> worker
#[derive(Debug, Clone)]
pub enum ActionedPrompt {
    Actioned { id: PromptId, others: Vec<PromptId> },
    NotFound { id: PromptId },
}

/// Start our backgroud polling and processing loops before dropping into running the tonic GRPC
/// server for handling incoming requestes from the Flutter UI client.
pub async fn run_daemon<L, S>(c: SnapdSocketClient, reload_handle: Handle<L, S>) -> Result<()>
where
    L: From<EnvFilter> + Send + Sync + 'static,
    S: 'static,
{
    let (tx_prompts, rx_prompts) = unbounded_channel();
    let (tx_actioned, rx_actioned) = unbounded_channel();

    let mut worker = Worker::new(rx_prompts, rx_actioned, c.clone());
    let active_prompt = worker.read_only_active_prompt();

    let path = env::var(SOCKET_ENV_VAR).expect("socket env var not set");
    if let Err(e) = fs::remove_file(&path) {
        error!("Failed to remove old socket file: {}. Error: {}", path, e);
    }
    let (server, listener) = new_server_and_listener(
        c.clone(),
        Arc::new(reload_handle),
        active_prompt,
        tx_actioned,
        path,
    );

    let mut set = JoinSet::new();

    debug!("spawning poll loop");
    let poll_loop = PollLoop::new(c, tx_prompts);
    set.spawn(async move {
        poll_loop
            .run()
            .await
            .inspect_err(|e| error!("poll loop exited with error: {:?}", e))
    });

    debug!("spawning worker thread");
    set.spawn(async move {
        worker
            .run()
            .await
            .inspect_err(|e| error!("worker exited with error: {:?}", e))
    });

    debug!("serving incoming grpc connections");
    set.spawn(async move {
        Server::builder()
            .add_service(server)
            .serve_with_incoming(UnixListenerStream::new(listener))
            .await
            .map_err(Into::into)
            .inspect_err(|e| error!("grpc server exited with error: {:?}", e))
    });

    if let Err(err) = set
        .join_next()
        .await
        .expect("non-empty join set")
        .expect("no panics in spawned tasks")
    {
        error!("join set returned error: {:?}", err);
    }
    error!("one or more tasks have returned - exiting");
    exit_with(crate::ExitStatus::Failure);
}
