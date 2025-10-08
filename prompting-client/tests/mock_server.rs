//! Integration tests to verify mock-server is in sync and works with the client implementation
//! These tests require the 'dry-run' feature to be enabled: cargo test --features dry-run

#![cfg(feature = "dry-run")]

use prompting_client::{
    snapd_client::{
        interfaces::{
            camera::CameraInterface, home::HomeInterface, microphone::MicrophoneInterface,
            SnapInterface,
        },
        Action, SnapdSocketClient, TypedPrompt,
    },
    Result,
};
use serde_json::Value;
use serial_test::serial;
use simple_test_case::test_case;
use std::{
    env,
    path::{Path, PathBuf},
    process::Stdio,
    time::Duration,
};
use tokio::{
    fs::File,
    io::{self, AsyncBufReadExt, AsyncWriteExt, BufReader, BufWriter},
    process::Command,
    spawn,
    sync::mpsc::{unbounded_channel, UnboundedReceiver},
    time::sleep,
};
use tokio_stream::{wrappers::LinesStream, StreamExt};

struct TestFixture {
    pipe_path: String,
    socket_path: String,
    workspace_path: PathBuf,
}

impl TestFixture {
    fn new() -> Self {
        let test_id = uuid::Uuid::new_v4();
        let manifest_dir = env!("CARGO_MANIFEST_DIR");
        let workspace = Path::new(manifest_dir)
            .parent()
            .expect("CARGO_MANIFEST_DIR should have a parent directory (workspace root)");

        Self {
            pipe_path: format!("/tmp/pipe.{}", test_id),
            socket_path: format!("/tmp/mock.sock.{}", test_id),
            workspace_path: workspace.into(),
        }
    }

    fn get_mock_server_path(&self) -> PathBuf {
        let mock_server_path = self.workspace_path.join("mock-server");
        let binary_path = mock_server_path.join("target/release/mock-server");

        if !binary_path.exists() {
            let output = std::process::Command::new("cargo")
                .args(&["build", "--release"])
                .current_dir(&mock_server_path)
                .output()
                .unwrap_or_else(|e| {
                    panic!(
                        "Failed to execute 'cargo build --release' in directory {:?}: {}",
                        mock_server_path, e
                    )
                });

            if !output.status.success() {
                let stderr = String::from_utf8_lossy(&output.stderr);
                let stdout = String::from_utf8_lossy(&output.stdout);
                panic!(
                "Failed to build mock-server in directory {:?}\nExit code: {:?}\nStdout:\n{}\nStderr:\n{}",
                mock_server_path, output.status.code(), stdout, stderr
                );
            }
        }

        binary_path
    }

    fn start_mock_server(&self) -> UnboundedReceiver<String> {
        env::set_var("SNAPD_SOCKET_OVERRIDE", &self.socket_path);

        let (tx, rx) = unbounded_channel();
        let binary_path = self.get_mock_server_path();
        let prompts_path = self.workspace_path.join("mock-server/prompts");

        // clone strings so they can be moved into the async task without moving out of &self
        let pipe_path = self.pipe_path.clone();
        let socket_path = self.socket_path.clone();

        spawn(async move {
            let relevant_logs = ["Get", "Reply", "Sending", "New"];

            let mut c = Command::new(&binary_path)
                .env("PIPE_PATH", pipe_path)
                .env("SOCKET_PATH", socket_path)
                .env("PROMPTS_PATH", prompts_path)
                .env("RUST_LOG", "info")
                .stdout(Stdio::piped())
                .kill_on_drop(true)
                .spawn()
                .unwrap_or_else(|e| {
                    panic!("Failed to start mock server from {:?}: {}", binary_path, e)
                });

            let stdout = BufReader::new(
                c.stdout
                    .as_mut()
                    .expect("Mock server stdout should be available"),
            );
            let mut stdout_lines = LinesStream::new(stdout.lines());

            while let Some(Ok(line)) = stdout_lines.next().await {
                if !relevant_logs.iter().any(|&p| line.contains(p)) {
                    continue;
                }

                if let Err(_) = tx.send(line) {
                    break;
                }
            }
        });

        rx
    }

    fn send_prompt_to_pipe(&self, prompt: Value) {
        let path = self.pipe_path.clone();

        spawn(async move {
            sleep(Duration::from_millis(5)).await;

            let pipe: File = File::options().write(true).open(path).await?;
            let mut writer = BufWriter::new(pipe);

            let content = serde_json::to_string(&prompt)?;

            writer.write_all(content.as_bytes()).await?;
            writer.flush().await?;

            Ok::<(), io::Error>(())
        });
    }
}

impl Drop for TestFixture {
    fn drop(&mut self) {
        let _ = std::fs::remove_file(std::path::Path::new(&self.pipe_path));
        let _ = std::fs::remove_file(std::path::Path::new(&self.socket_path));
    }
}

macro_rules! reply {
    ($client:expr, $id:expr, $prompt:expr, $action:expr) => {
        match $prompt {
            TypedPrompt::Camera(_) => {
                $client
                    .reply_to_prompt(
                        $id,
                        CameraInterface::prompt_to_reply($prompt.try_into()?, $action).into(),
                    )
                    .await?
            }
            TypedPrompt::Home(_) => {
                $client
                    .reply_to_prompt(
                        $id,
                        HomeInterface::prompt_to_reply($prompt.try_into()?, $action).into(),
                    )
                    .await?
            }
            TypedPrompt::Microphone(_) => {
                $client
                    .reply_to_prompt(
                        $id,
                        MicrophoneInterface::prompt_to_reply($prompt.try_into()?, $action).into(),
                    )
                    .await?
            }
        }
    };
}

#[tokio::test]
#[serial]
async fn ensure_prompting_is_enabled() -> Result<()> {
    let test = TestFixture::new();
    let _rx = test.start_mock_server();

    // wait for the mock server to start
    sleep(Duration::from_millis(100)).await;

    let c = SnapdSocketClient::new().await;
    assert!(c.is_prompting_enabled().await?, "prompting is not enabled");

    Ok(())
}

#[test_case(Action::Allow; "allow")]
#[test_case(Action::Deny; "deny")]
#[tokio::test]
#[serial]
async fn all_initial_state_prompts_are_valid(action: Action) -> Result<()> {
    let test = TestFixture::new();
    let mut rx = test.start_mock_server();

    // wait for the mock server to start
    sleep(Duration::from_millis(100)).await;

    let c = SnapdSocketClient::new().await;
    let pending = c.all_pending_prompt_details().await?;

    assert_eq!(pending.len(), 4, "expected 4 prompts");
    let log = rx.recv().await;

    assert!(log.is_some_and(|l| l.contains("Get current pending prompts")));
    for p in pending {
        let id = p.id();
        let p = c.prompt_details(&id).await?;

        let log = rx.recv().await;
        assert!(log.is_some_and(|l| l.contains(&format!("Get pending prompt: {}", id.0))));

        reply!(c, id, p, action);

        let log = rx.recv().await;
        assert!(log.is_some_and(|l| l.contains(&format!("Reply to prompt {}", id.0))));
    }

    let pending = c.all_pending_prompt_details().await?;
    assert_eq!(pending.len(), 0, "expected no prompt");

    Ok(())
}

#[test_case(Action::Allow; "allow")]
#[test_case(Action::Deny; "deny")]
#[tokio::test]
#[serial]
async fn send_through_pipe(action: Action) -> Result<()> {
    let prompt = serde_json::json!({
        "id": "0000000000000000",
        "timestamp": "2025-08-20T16:17:44.28198468+02:00",
        "snap": "foo",
        "pid": 136211,
        "interface": "camera",
        "constraints": {
            "requested-permissions": [
                "access"
            ],
            "available-permissions": [
                "access"
            ]
        }
    });

    let test = TestFixture::new();
    let mut rx = test.start_mock_server();

    // wait for the mock server to start
    sleep(Duration::from_millis(100)).await;

    test.send_prompt_to_pipe(prompt);

    let mut c = SnapdSocketClient::new().await;
    c.pending_prompt_notices().await?;

    let log = rx.recv().await;
    assert!(log.is_some_and(|l| l.contains("New listener to the long polling api")));

    let log = rx.recv().await;
    assert!(log.is_some_and(|l| l.contains("Sending data into the pipe")));

    let pending = c.all_pending_prompt_details().await?;
    assert_eq!(pending.len(), 5, "expected 5 prompts");

    let log = rx.recv().await;
    assert!(log.is_some_and(|l| l.contains("Get current pending prompts")));

    for p in pending {
        let id = p.id();
        let p = c.prompt_details(&id).await?;

        let log = rx.recv().await;
        assert!(log.is_some_and(|l| l.contains(&format!("Get pending prompt: {}", id.0))));

        reply!(c, id, p, action);

        let log = rx.recv().await;
        assert!(log.is_some_and(|l| l.contains(&format!("Reply to prompt {}", id.0))));
    }

    let pending = c.all_pending_prompt_details().await?;
    assert_eq!(pending.len(), 0, "expected no prompt");

    Ok(())
}
