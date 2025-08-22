use crate::{Action, AppState, prompts::Prompts};

use axum::extract::Query;
use axum::{
    extract::{Json, Path, State},
    http::StatusCode,
    response::{IntoResponse, Response},
};
use chrono::Utc;
use serde::Deserialize;
use serde_json::{Value, json};
use std::{sync::Arc, time::Duration};
use tokio::time::timeout;
use tracing::info;

#[derive(Debug, Deserialize)]
pub struct PollNotices {
    #[serde(default)]
    timeout: Option<String>,

    #[serde(default, rename = "types")]
    _types: Option<String>,
    #[serde(default, rename = "after")]
    _after: Option<String>,
}

fn parse_timeout(timeout: &Option<String>) -> Duration {
    if let Some(t) = timeout {
        let number = t[..t.len() - 1].parse::<u64>();

        match (number, t.chars().last()) {
            (Ok(n), Some('h')) => return Duration::from_secs(n * 3600),
            (Ok(n), Some('m')) => return Duration::from_secs(n * 60),
            (Ok(n), Some('s')) => return Duration::from_secs(n),
            _ => return Duration::from_secs(3600),
        }
    }

    Duration::from_secs(3600)
}

pub async fn poll_notices(
    State(data): State<Arc<AppState>>,
    Query(query): Query<PollNotices>,
) -> Response {
    info!(
        "New listener to the long polling api [total listener {}]",
        data.tx.receiver_count()
    );

    let duration = parse_timeout(&query.timeout);

    let mut rx = data.tx.subscribe();
    match timeout(duration, rx.recv()).await {
        Ok(Ok((mut prompt, Action::New))) => {
            let (id, key) = {
                let mut hm = data.prompts.lock().await;

                // progressive id based on the current state of the prompts
                let id = hm
                    .keys()
                    .map(|k| u64::from_str_radix(k, 16).unwrap())
                    .max()
                    .unwrap_or(0)
                    + 1;
                let key = format!("{id:016}");
                let timestamp = Utc::now().format("%Y-%m-%dT%H:%M:%S.%fZ").to_string();

                prompt["id"] = json!(key);
                prompt["timestamp"] = json!(timestamp);

                hm.insert(key.clone(), prompt.clone());

                (id, key)
            };

            let notice = {
                let mut hm = data.notices.lock().await;
                let notice = Prompts::make_notice(id, &key);
                hm.insert(key, notice.clone());

                notice
            };

            make_success(notice).into_response()
        }

        Ok(Ok((prompt, Action::Update))) => {
            let mut hm = data.notices.lock().await;
            let id = prompt["id"].as_str().unwrap();
            let notice = hm.get_mut(id).unwrap();

            if let Some(obj) = notice.as_array_mut().and_then(|arr| arr.get_mut(0)) {
                obj["last-data"] = json!({"resolved": "replied"});
            }

            make_success(notice.clone()).into_response()
        }

        Ok(_) => Json(json!("Receiving error")).into_response(),
        _ => Json(json!([])).into_response(),
    }
}

pub async fn list_prompts(State(data): State<Arc<AppState>>) -> impl IntoResponse {
    info!("list_prompts api");

    let hm = data.prompts.lock().await;
    let prompts = hm.values().collect::<Vec<_>>();

    make_success(json!(prompts))
}

pub async fn prompt(State(data): State<Arc<AppState>>, Path(id): Path<String>) -> Response {
    info!("prompt api");

    let hm = data.prompts.lock().await;
    match hm.get(&id) {
        Some(value) => make_success(value.clone()).into_response(),
        _ => make_not_found().into_response(),
    }
}

// struct PromptReply {}

pub async fn post_prompt(
    State(data): State<Arc<AppState>>,
    Path(id): Path<String>,
    // Json(payload): Json<PromptReply>,
) -> Response {
    let id = u64::from_str_radix(&id.to_lowercase(), 16).unwrap();
    let key = format!("{id:016}");

    info!("Reply to prompt {id}");

    let mut hm = data.prompts.lock().await;
    match hm.remove(&key) {
        Some(prompt) => {
            let tx = data.tx.clone();
            let _ = tx.send((prompt, Action::Update));

            make_success(json!(vec![key])).into_response()
        }
        _ => make_not_found().into_response(),
    }
}

pub async fn metadata(Path(_): Path<String>) -> impl IntoResponse {
    make_success(json!({
        "install-date": "2025-08-08T09:15:01.505417578+02:00",
        "publisher": {
            "display-name": "foo",
        }
    }))
}

pub async fn system_info() -> impl IntoResponse {
    make_success(json!({
        "features": {
            "apparmor-prompting": {
                "supported": true,
                "enabled": true
            }
        }
    }))
}

pub async fn handler_500() -> impl IntoResponse {
    let body = json!({
        "type": "error",
        "status-code": 500,
        "status": "Internal Server Error",
    });

    (StatusCode::INTERNAL_SERVER_ERROR, Json(body))
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

fn make_not_found() -> impl IntoResponse {
    Json(json!({
        "type": "error",
        "status-code": 404,
        "status": "NotFound",
        "result": {
            "message": "cannot find prompt with the given ID for the given user",
            "kind": "interfaces-requests-prompt-not-found"
        },
    }))
}
