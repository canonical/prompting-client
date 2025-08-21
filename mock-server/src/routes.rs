use crate::AppState;

use axum::{
    Json,
    extract::{Path, State},
    http::StatusCode,
    response::{IntoResponse, Response},
};
use serde_json::{Value, json};
use std::sync::Arc;

pub async fn notices(State(data): State<Arc<AppState>>) -> Response {
    let mut rx = data.tx.subscribe();

    // todo: add initial fake prompts

    match rx.recv().await {
        Ok(msg) => {
            println!("{msg}");
            make_success(msg).into_response()
        }
        _ => Json(json!("Receiving error")).into_response(),
    }
}

pub async fn list_prompts(State(data): State<Arc<AppState>>) -> impl IntoResponse {
    let hm = data.prompts.lock().await;
    let prompts = hm.values().collect::<Vec<_>>();

    make_success(json!(prompts))
}

pub async fn prompt(Path(id): Path<u64>, State(data): State<Arc<AppState>>) -> Response {
    let hm = data.prompts.lock().await;

    match hm.get(&id) {
        Some(value) => make_success(value.clone()).into_response(),
        _ => make_not_found().into_response(),
    }
}

pub async fn post_prompt(
    Path(id): Path<u64>,
    State(data): State<Arc<AppState>>,
) -> impl IntoResponse {
    let mut hm = data.prompts.lock().await;

    // TODO: when a reply is received remove the prompt from hm

    // #[serde(rename_all = "kebab-case")]
    // pub struct PromptReply<I>
    // where
    //     I: SnapInterface,
    // {
    //     pub(crate) action: Action,
    //     pub(crate) lifespan: Lifespan,
    //     #[serde(skip_serializing_if = "Option::is_none")]
    //     pub(crate) duration: Option<String>,
    //     pub(crate) constraints: I::ReplyConstraints,
    // }

    // #[strum(serialize_all = "lowercase")]
    // pub enum Action {
    //     Allow,
    //     #[default]
    //     Deny,
    // }

    // #[serde(rename_all = "lowercase")]
    // #[strum(serialize_all = "lowercase")]
    // pub enum Lifespan {
    //     #[default]
    //     Single,
    //     Session, // part of the snapd API but not currently in use
    //     Forever,
    //     Timespan, // supported in snapd but not currently used in the UI
    // }

    let body = json!({});

    hm.insert(id, body.clone());

    (StatusCode::CREATED, Json(body))
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
        "status-code": "200",
        "status": "OK",
        "result": result,
        "warning-timestamp": "2025-08-06T06:44:48.070480685Z",
        "warning-count": 1
    }))
}

fn make_not_found() -> impl IntoResponse {
    Json(json!({
        "type": "error",
        "status-code": "404",
        "status": "NotFound",
        "result": {
            "message": "cannot find prompt with the given ID for the given user",
            "kind": "interfaces-requests-prompt-not-found"
        },
    }))
}
