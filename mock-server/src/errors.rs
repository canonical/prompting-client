use axum::{
    Json,
    http::StatusCode,
    response::{IntoResponse, Response},
};
use serde_json::json;
use tracing::error;

pub struct NotFoundError(pub anyhow::Error);

impl IntoResponse for NotFoundError {
    fn into_response(self) -> Response {
        error!("{}", self.0);

        let body = json!({
            "type": "error",
            "status-code": 404,
            "status": "Not Found",
            "result": {
                "message": "cannot find prompt with the given ID for the given user",
                "kind": "interfaces-requests-prompt-not-found"
            },
        });

        (StatusCode::NOT_FOUND, Json(body)).into_response()
    }
}

impl<E> From<E> for NotFoundError
where
    E: Into<anyhow::Error>,
{
    fn from(err: E) -> Self {
        Self(err.into())
    }
}

pub async fn not_found() -> Result<Response, NotFoundError> {
    Err(NotFoundError(anyhow::anyhow!("not found")))
}
