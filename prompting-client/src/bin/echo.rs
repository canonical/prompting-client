use clap::Parser;
use prompting_client::{
    cli_actions::run_echo_loop, snapd_client::SnapdSocketClient, Error, Result,
};

/// A simple echo prompting client for apparmor prompting that echos all prompts seen on the system
/// for the user running it.
#[derive(Debug, Parser)]
#[clap(about, long_about = None)]
struct Args {
    /// Optionally record events to a specified file on Ctrl-C
    #[clap(short, long, value_name = "FILE")]
    record: Option<String>,
}

#[tokio::main]
async fn main() -> Result<()> {
    let Args { record } = Args::parse();
    let mut c = SnapdSocketClient::default();

    if !c.is_prompting_enabled().await? {
        eprintln!("the prompting feature is not enabled: exiting");
        return Err(Error::NotEnabled);
    }

    run_echo_loop(&mut c, record).await
}
