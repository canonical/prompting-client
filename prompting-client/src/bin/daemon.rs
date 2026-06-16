//! The daemon prompting client for apparmor prompting
use prompting_client::{
    DEFAULT_LOG_LEVEL, ExitStatus, Result, daemon::run_daemon, exit_with, log_filter,
    snapd_client::SnapdSocketClient,
};
use std::{env, io::stdout};
use tracing::{info, subscriber::set_global_default};
use tracing_subscriber::FmtSubscriber;

unsafe extern "C" {
    fn geteuid() -> u32;
}

fn is_effective_root() -> bool {
    unsafe { geteuid() == 0 }
}

fn is_loginable_graphical_session() -> bool {
    if env::var("XDG_SESSION_CLASS").as_deref() != Ok("user") {
        return false;
    }

    match env::var("XDG_SESSION_TYPE").as_deref() {
        Ok("wayland") => env::var_os("WAYLAND_DISPLAY").is_some(),
        Ok("x11") => env::var_os("DISPLAY").is_some(),
        _ => false,
    }
}

#[tokio::main]
async fn main() -> Result<()> {
    let log_level = std::env::var("RUST_LOG").unwrap_or(DEFAULT_LOG_LEVEL.to_string());

    let builder = FmtSubscriber::builder()
        .with_env_filter(log_filter(&log_level))
        .with_writer(stdout)
        .with_filter_reloading();

    let reload_handle = builder.reload_handle();
    let subscriber = builder.finish();

    set_global_default(subscriber).expect("unable to set a global tracing subscriber");

    if is_effective_root() {
        info!("running as root, failing daemon startup");
        exit_with(ExitStatus::Failure);
    }

    if !is_loginable_graphical_session() {
        info!("not running in a loginable graphical session, failing daemon startup");
        exit_with(ExitStatus::Failure);
    }

    // Shutdown the daemon when running in the CI since there's no display to connect to.
    if std::env::var("PROMPTING_CI").is_ok() {
        info!("running in CI, shutting down the daemon");
        exit_with(ExitStatus::Success);
    }

    let c = SnapdSocketClient::new().await;
    c.exit_if_prompting_not_enabled().await?;

    run_daemon(c, reload_handle).await
}
