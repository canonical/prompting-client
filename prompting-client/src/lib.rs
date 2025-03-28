#![warn(
    clippy::complexity,
    clippy::correctness,
    clippy::style,
    future_incompatible,
    missing_debug_implementations,
    rust_2018_idioms,
    rustdoc::all,
    clippy::undocumented_unsafe_blocks
)]

use hyper::StatusCode;
use prompt_sequence::MatchError;

pub mod cli_actions;
pub mod daemon;
pub mod prompt_sequence;
pub mod protos;
pub mod snapd_client;

mod recording;
mod socket_client;
mod util;

use snapd_client::SnapdError;

pub(crate) const SNAP_NAME: &str = "prompting-client";
pub const SOCKET_ENV_VAR: &str = "PROMPTING_CLIENT_SOCKET";
pub const DEFAULT_LOG_LEVEL: &str = "info";

pub fn log_filter(filter: &str) -> String {
    format!("{filter},hyper=error,h2=error")
}

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error(transparent)]
    Hyper(#[from] hyper::Error),

    #[error(transparent)]
    HyperHttp(#[from] hyper::http::Error),

    #[error(transparent)]
    Io(#[from] std::io::Error),

    #[error(transparent)]
    Json(#[from] serde_json::Error),

    #[error(transparent)]
    Regex(#[from] regex::Error),

    #[error("failed prompt sequence: {error}")]
    FailedPromptSequence { error: MatchError },

    #[error("invalid custom permissions: requested={requested:?} but available={available:?}")]
    InvalidCustomPermissions {
        requested: Vec<String>,
        available: Vec<String>,
    },

    #[error("{version} is not supported recording version.")]
    InvalidRecordingVersion { version: u8 },

    #[error("invalid script variable. Expected 'key:value' but saw {raw:?}")]
    InvalidScriptVariable { raw: String },

    #[error("{uri} is not valid: {reason}")]
    InvalidUri { reason: &'static str, uri: String },

    #[error("the apparmor-prompting feature is not available")]
    NotAvailable,

    #[error("the apparmor-prompting feature is not enabled")]
    NotEnabled,

    #[error("the apparmor-prompting feature is not supported: {reason}")]
    NotSupported { reason: String },

    #[error("error message returned from snapd: {message}")]
    SnapdError {
        status: StatusCode,
        message: String,
        err: Box<SnapdError>,
    },

    #[error("{interface} is not currently supported for apparmor prompting")]
    UnsupportedInterface { interface: String },

    #[error("unable to update log filter: {reason}")]
    UnableToUpdateLogFilter { reason: String },
}

/// Convenience Result type where E is an [Error] by default.
pub type Result<T, E = Error> = std::result::Result<T, E>;
