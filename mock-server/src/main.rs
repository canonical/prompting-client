use axum::{
    Router,
    routing::{get, post},
};

use serde_json::Value;
use tokio::{
    io::{AsyncReadExt, BufReader},
    sync::{Mutex, broadcast},
};
use tracing::info;
use tracing_subscriber::EnvFilter;

use std::{collections::HashMap, sync::Arc, time::Duration};

use anyhow::Result;

use crate::routes::*;
use crate::{pipe::Pipe, prompts::Prompts, socket::Socket};

struct AppState {
    last_prompt_id: Mutex<u64>,
    notices: Mutex<HashMap<String, Value>>,
    prompts: Mutex<HashMap<String, Value>>,
    tx: broadcast::Sender<(Value, Action)>,
}

#[derive(Clone, Copy)]
pub enum Action {
    New,
    Update,
}

mod pipe;
mod prompts;
mod routes;
mod socket;

#[tokio::main]
async fn main() -> Result<()> {
    tracing_subscriber::fmt()
        .compact()
        .with_env_filter(EnvFilter::from_default_env())
        .init();

    let pipe_path = std::env::var("PIPE_PATH")?;
    let socket_path = std::env::var("SOCKET_PATH")?;

    // A broadcast channel is used instead of a standard mpsc channel because it allows
    // multiple receivers to subscribe and receive all messages sent through the channel.
    // This is useful for our long polling api where the same data needs to be sent
    // to multiple independent consumers.
    let (tx, _) = broadcast::channel::<(Value, Action)>(16);

    let prompts = Prompts::read_initial_state("prompts");
    let mut notices = HashMap::new();
    for (k, _) in &prompts {
        let value = Prompts::make_notice(k.parse::<u64>()?, k);

        notices.insert(k.clone(), value);
    }

    let data = Arc::new(AppState {
        last_prompt_id: Mutex::new(prompts.len() as u64),
        notices: Mutex::new(notices),
        prompts: Mutex::new(prompts),
        tx: tx.clone(),
    });

    let app = Router::new()
        .route("/v2/notices", get(poll_notices))
        .route("/v2/interfaces/requests/prompts", get(list_prompts))
        .route(
            "/v2/interfaces/requests/prompts/{id:[0-9a-fA-F]+}",
            get(prompt),
        )
        .route(
            "/v2/interfaces/requests/prompts/{id:[0-9a-fA-F]+}",
            post(post_prompt),
        )
        .route("/v2/snaps/{snapname}", get(metadata))
        .route("/v2/system-info", get(system_info))
        .fallback(handler_500)
        .with_state(data);

    tokio::spawn(async move {
        info!("Initializing pipe");

        let pipe = Pipe::create(&pipe_path).await.unwrap();
        let mut reader = BufReader::new(pipe);

        loop {
            let mut buf = String::new();
            reader.read_to_string(&mut buf).await.unwrap();

            if let Ok(json) = serde_json::from_str::<serde_json::Value>(&buf) {
                info!("Sending data into the pipe: {json}");
                let _ = tx.send((json, Action::New));
            }

            tokio::time::sleep(Duration::from_millis(100)).await;
        }
    });

    info!("Starting mock-server");

    let listener = Socket::create(&socket_path).await?;

    axum::serve(listener, app).await?;

    Ok(())
}
