use crate::errors::NotFoundError;
use crate::{Action, AppState, prompts::Prompts};

use anyhow::{Context, anyhow};
use axum::extract::Query;
use axum::{
    extract::{Json, Path, State},
    response::IntoResponse,
};
use serde::Deserialize;
use serde_json::{Value, json};
use std::{sync::Arc, time::Duration};
use tokio::time::timeout;
use tracing::{info, warn};

#[derive(Debug, Deserialize)]
pub struct PollNotices {
    #[serde(default)]
    timeout: Option<String>,

    #[serde(default, rename = "types")]
    _types: Option<String>,
    #[serde(default, rename = "after")]
    _after: Option<String>,
}

/// Parses the timeout string from the query parameters and returns a `Duration`.
///
/// Supported formats:
/// - "10s" for 10 seconds
/// - "5m" for 5 minutes
/// - "1h" for 1 hour
///
/// Defaults to 1 hour if parsing fails or is not provided.
fn parse_timeout(timeout: &Option<String>) -> Duration {
    if let Some(t) = timeout {
        let number = t[..t.len() - 1].parse::<u64>();

        match (number, t.chars().last()) {
            (Ok(n), Some('h')) => return Duration::from_secs(n * 3600),
            (Ok(n), Some('m')) => return Duration::from_secs(n * 60),
            (Ok(n), Some('s')) => return Duration::from_secs(n),
            _ => (),
        }
    }

    Duration::from_secs(3600)
}

pub async fn poll_notices(
    State(data): State<Arc<AppState>>,
    Query(query): Query<PollNotices>,
) -> Result<impl IntoResponse, NotFoundError> {
    let mut rx = data.tx.subscribe();

    info!(
        "New listener to the long polling api [total listener {}]",
        data.tx.receiver_count()
    );

    let duration = parse_timeout(&query.timeout);

    match timeout(duration, rx.recv()).await {
        Ok(Ok((mut prompt, Action::New))) => {
            let (id, key) = {
                info!("Add a new pending prompt");

                let mut hm = data.prompts.lock().await;
                let mut id = data.last_prompt_id.lock().await;

                *id += 1;

                let key = format!("{:016x}", *id);
                let timestamp = Prompts::timestamp();

                prompt["id"] = json!(key);
                prompt["timestamp"] = json!(timestamp);

                hm.insert(key.clone(), prompt.clone());

                (*id, key)
            };

            info!("Make a notice for the new pending prompt");

            let notice = {
                let mut hm = data.notices.lock().await;
                let notice = Prompts::make_notice(id, &key);
                hm.insert(key, notice.clone());

                notice
            };

            Ok(make_success(notice))
        }

        Ok(Ok((prompt, Action::Update))) => {
            let mut hm = data.notices.lock().await;
            let id = prompt["id"]
                .as_str()
                .context("no `id` field found in prompt")?;
            let notice = hm
                .get_mut(id)
                .context(format!("`{id}` is not a valid notice id"))?;

            info!("Update the notice for prompt: {id}");

            if let Some(obj) = notice.as_array_mut().and_then(|arr| arr.get_mut(0)) {
                obj["last-data"] = json!({"resolved": "replied"});
            }

            Ok(make_success(notice.clone()))
        }

        Ok(Err(err)) => Err(NotFoundError(anyhow!("Error receiving from pipe: {err}"))),

        _ => {
            warn!("Timeout expired after {}s", duration.as_secs());
            Ok(make_success(json!([])))
        }
    }
}

pub async fn list_prompts(State(data): State<Arc<AppState>>) -> impl IntoResponse {
    info!("Get current pending prompts");

    let hm = data.prompts.lock().await;
    let prompts = hm.values().collect::<Vec<_>>();

    make_success(json!(prompts))
}

pub async fn prompt(
    State(data): State<Arc<AppState>>,
    Path(id): Path<String>,
) -> Result<impl IntoResponse, NotFoundError> {
    let id = u64::from_str_radix(&id.to_lowercase(), 16)
        .context(format!("`{id}` is not a valid hex string"))?;
    let key = format!("{id:016x}");

    info!("Get pending prompt: {key}");

    let hm = data.prompts.lock().await;
    let value = hm
        .get(&key)
        .cloned()
        .context(format!("`{key}` is not a valid prompt key"))?;

    Ok(make_success(value))
}

pub async fn post_prompt(
    State(data): State<Arc<AppState>>,
    Path(id): Path<String>,
    Json(payload): Json<Value>,
) -> Result<impl IntoResponse, NotFoundError> {
    let id = u64::from_str_radix(&id.to_lowercase(), 16)
        .context(format!("`{id}` is not a valid hex string"))?;
    let key = format!("{id:016x}");

    info!("Reply to prompt {key} with payload: {payload}");

    let mut hm = data.prompts.lock().await;
    let prompt = hm
        .remove(&key)
        .context(format!("`{key}` is not a valid prompt key"))?;

    let tx = data.tx.clone();
    let _ = tx.send((prompt, Action::Update));

    Ok(make_success(json!(vec![key])))
}

pub async fn metadata(Path(snapname): Path<String>) -> impl IntoResponse {
    info!("Get metadata for {snapname}");

    make_success(json!({
        "install-date": "2025-08-08T09:15:01.505417578+02:00",
        "publisher": {
            "display-name": "foo",
        }
    }))
}

pub async fn system_info() -> impl IntoResponse {
    info!("Get system info");

    make_success(json!({
        "features": {
            "apparmor-prompting": {
                "supported": true,
                "enabled": true
            }
        }
    }))
}

fn make_success(result: Value) -> impl IntoResponse {
    Json(json!({
        "type": "sync",
        "status-code": 200,
        "status": "OK",
        "result": result,
        "warning-timestamp": "2025-08-06T06:44:48.070480685Z",
        "warning-count": 1
    }))
}
