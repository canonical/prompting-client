//! The daemon prompting client for apparmor prompting
use prompting_client::{
    daemon::run_daemon, log_filter, snapd_client::SnapdSocketClient, Error, Result,
    DEFAULT_LOG_LEVEL,
};
use std::{env, io::stdout};
use tracing::subscriber::set_global_default;
use tracing::warn;
use tracing_subscriber::{layer::SubscriberExt, FmtSubscriber};

#[tokio::main]
async fn main() -> Result<()> {
    let builder = FmtSubscriber::builder()
        .with_env_filter(log_filter(DEFAULT_LOG_LEVEL))
        .with_writer(stdout)
        .with_filter_reloading();

    let reload_handle = builder.reload_handle();
    let journald_layer = tracing_journald::layer().expect("unable to open journald socket");
    let subscriber = builder.finish().with(journald_layer);

    set_global_default(subscriber).expect("unable to set a global tracing subscriber");

    let c = SnapdSocketClient::default();

    // If prompting is not currently enabled then we exit non-0 to ensure that systemd does not
    // restart us. Instead, snapd will ensure that we are started when the flag is enabled.
    if !c.is_prompting_enabled().await? {
        warn!("the prompting feature is not enabled: exiting");
        return Err(Error::NotEnabled);
    }

    // If we can't see a valid X11 or Wayland display then we need to exit 0 and wait for systemd
    // to restart us again until it is there. We are deliberately not logging anything here so that
    // we avoid spamming the system log while we wait for the disply environment variable to be
    // set.
    let have_display = env::vars().any(|(k, _)| k == "DISPLAY" || k == "WAYLAND_DISPLAY");
    if !have_display {
        return Ok(());
    }

    run_daemon(c, reload_handle).await
}
