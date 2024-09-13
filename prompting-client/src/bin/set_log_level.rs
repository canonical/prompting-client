use clap::Parser;
use prompting_client::cli_actions::set_log_level;
use std::process::exit;

/// Set the logging level for a running instance of the prompting client daemon
#[derive(Debug, Parser)]
#[clap(about, long_about = None)]
struct Args {
    /// The filter to use for setting the logging level
    #[clap(short, long, value_name = "FILTER")]
    level: String,
}

#[tokio::main]
async fn main() {
    let Args { level } = Args::parse();

    match set_log_level(level).await {
        Ok(current) => println!("logging level set to: {current}"),
        Err(e) => {
            eprintln!("{e}");
            exit(1);
        }
    }
}
