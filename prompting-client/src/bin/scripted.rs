//! A simple command line prompting client
use clap::Parser;
use prompting_client::{
    cli_actions::run_scripted_client_loop, snapd_client::SnapdSocketClient, Error, Result,
};
use std::{io::stderr, process::exit};
use tracing::subscriber::set_global_default;
use tracing_subscriber::FmtSubscriber;

/// Run a scripted client expecting a given sequence of prompts.
///
/// If the provided prompt sequence completes cleanly the client will print "success" on standard
/// out. If there are any errors then the first error will be printed as "error: $errorMessage" on
/// standard out and the client will exit with a non-zero exit code.
#[derive(Debug, Parser)]
#[clap(about, long_about = None)]
struct Args {
    #[clap(short, long, action = clap::ArgAction::Count)]
    verbose: u8,

    /// The path to the input JSON file
    #[clap(short, long, value_name = "FILE")]
    script: String,

    #[clap(long, action = clap::ArgAction::Append)]
    var: Vec<String>,

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
        var,
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

    let vars = parse_vars(&var)?;

    match run_scripted_client_loop(&mut c, script, &vars, grace_period).await {
        Ok(_) => println!("success"),
        Err(e) => {
            println!("error: {e}");
            exit(1);
        }
    }

    Ok(())
}

fn parse_vars(raw: &[String]) -> Result<Vec<(&str, &str)>> {
    let mut vars: Vec<(&str, &str)> = Vec::with_capacity(raw.len());

    for s in raw.iter() {
        match s.split_once(':') {
            Some((k, v)) => vars.push((k.trim(), v.trim())),
            None => return Err(Error::InvalidScriptVariable { raw: s.clone() }),
        }
    }

    Ok(vars)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_vars_works() {
        let raw_vars = vec![
            "foo:bar".into(),
            "a: b".to_string(),
            "x :y".to_string(),
            "1 : 2".to_string(),
        ];

        match parse_vars(&raw_vars) {
            Err(e) => panic!("ERROR: {e}"),
            Ok(vars) => assert_eq!(
                vars,
                vec![("foo", "bar"), ("a", "b"), ("x", "y"), ("1", "2")]
            ),
        }
    }
}
