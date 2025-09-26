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

    #[error(transparent)]
    ToStrError(#[from] hyper::header::ToStrError),

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

    #[error("unable to convert prompt to {interface} prompt")]
    PromptConversionError { interface: String },

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

    #[error("snapd replied with status code {status} but didn't provide a valid error response")]
    InvalidSnapdErrorResponse { status: StatusCode },

    #[error("snapd provided an icon without a content-type")]
    MissingContentType,
}

/// Convenience Result type where E is an [Error] by default.
pub type Result<T, E = Error> = std::result::Result<T, E>;

/// Represents the possible exit statuses for the prompting client.
#[derive(Debug, Clone, Copy)]
pub enum ExitStatus {
    Success = 0,
    Failure = 1,
    PromptingDisabled = 8,
}

pub fn exit_with(status: ExitStatus) -> ! {
    std::process::exit(status as i32);
}
