use axum::{
    Router,
    routing::{get, post},
};

use serde_json::Value;
use tokio::{
    io::{AsyncReadExt, BufReader},
    sync::{Mutex, broadcast},
};

use std::{collections::HashMap, sync::Arc};

use anyhow::Result;

use crate::routes::*;
use crate::{pipe::Pipe, prompts::Prompts, socket::Socket};

struct AppState {
    tx: broadcast::Sender<Value>,
    prompts: Mutex<HashMap<u64, Value>>,
}

mod pipe;
mod prompts;
mod routes;
mod socket;

#[tokio::main]
async fn main() -> Result<()> {
    let pipe_path = std::env::var("PIPE_PATH")?;
    let socket_path = std::env::var("SOCKET_PATH")?;

    // A broadcast channel is used instead of a standard mpsc channel because it allows
    // multiple receivers to subscribe and receive all messages sent through the channel.
    // This is useful for our long polling api where the same data needs to be sent
    // to multiple independent consumers.
    let (tx, _) = broadcast::channel::<Value>(16);

    let data = Arc::new(AppState {
        tx: tx.clone(),
        prompts: Mutex::new(Prompts::read_initial_state("prompts")),
    });

    let app = Router::new()
        .route("/v2/notices", get(notices))
        .route("/v2/interfaces/requests/prompts", get(list_prompts))
        .route("/v2/interfaces/requests/prompts/{id}", get(prompt))
        .route("/v2/interfaces/requests/prompts/{id}", post(post_prompt))
        .route("/v2/snaps/{snapname}", get(metadata))
        .route("/v2/system-info", get(system_info))
        .fallback(handler_500)
        .with_state(data.clone());

    tokio::spawn(async move {
        let pipe = Pipe::create(&pipe_path).await.unwrap();
        let mut reader = BufReader::new(pipe);

        loop {
            let mut buf = String::new();
            reader.read_to_string(&mut buf).await.unwrap();

            if let Ok(json) = serde_json::from_str::<serde_json::Value>(&buf) {
                let _ = tx.send(json);
            }
        }
    });

    let listener = Socket::create(&socket_path).await?;

    axum::serve(listener, app).await?;

    Ok(())
}
