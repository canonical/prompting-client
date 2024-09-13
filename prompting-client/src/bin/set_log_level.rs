//! This is a helper command for setting our logging filter within the daemon while it is running.
//! Doing this involves having to send a GRPC message to the daemon which inolves more plumbing
//! than we'd ideally like but it allows us to update the filter without having to restart the
//! daemon.
//!
//! The docs on the command itself cover how to set simple logging levels but the tracing framework
//! we are using actually supports a rich syntax for how these filters are written. As and when we
//! need to use this in anger, the docs can be found here:
//!   https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.EnvFilter.html
use clap::Parser;
use prompting_client::cli_actions::set_logging_filter;
use std::process::exit;

/// Set the logging level for a running instance of the prompting client daemon.
///
/// Simple usage of this command involves specifying a level based filter for what logs are written
/// to the system journal by the prompting-client daemon. The supported levels are (in order of
/// least to most verbose):
///
///   - error
///   - warn
///   - info
///   - debug
///   - trace
///
/// The default level is "info".
#[derive(Debug, Parser)]
#[clap(about, long_about = None)]
struct Args {
    /// The filter to use for determining what gets logged
    #[clap(short, long, value_name = "FILTER")]
    filter: String,
}

#[tokio::main]
async fn main() {
    let Args { filter } = Args::parse();

    match set_logging_filter(filter).await {
        Ok(current) => println!("logging filter set to: {current}"),
        Err(e) => {
            eprintln!("{e}");
            exit(1);
        }
    }
}
