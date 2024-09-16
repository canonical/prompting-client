//! A simple command line prompting client
use clap::Parser;
use prompting_client::{
    cli_actions::run_scripted_client_loop, snapd_client::SnapdSocketClient, Result,
};
use std::io::stderr;
use tracing::subscriber::set_global_default;
use tracing_subscriber::FmtSubscriber;

/// Run a scripted client expecting a given sequence of prompts
#[derive(Debug, Parser)]
#[clap(about, long_about = None)]
struct Args {
    #[clap(short, long, action = clap::ArgAction::Count)]
    verbose: u8,

    /// The path to the input JSON file
    #[clap(short, long, value_name = "FILE")]
    script: String,

    /// The number of seconds to wait following completion of the script to check for any
    /// unexpected additional prompts.
    #[clap(short, long, value_name = "SECONDS")]
    grace_period: Option<u64>,
}

#[tokio::main]
async fn main() -> Result<()> {
    let Args {
        verbose,
        script,
        grace_period,
    } = Args::parse();

    if verbose > 0 {
        let level = if verbose == 1 { "info" } else { "debug" };
        let subscriber = FmtSubscriber::builder()
            .with_env_filter(level)
            .with_writer(stderr)
            .finish();
        set_global_default(subscriber).expect("unable to set a global tracing subscriber");
    }

    let mut c = SnapdSocketClient::default();
    c.exit_if_prompting_not_enabled().await?;

    run_scripted_client_loop(&mut c, script, grace_period).await
}
