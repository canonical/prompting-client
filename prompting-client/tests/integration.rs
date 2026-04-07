//! Integration tests against a running snapd supporting apparmor-prompting
//!
//! These tests are written to interact with the system's running snapd process with the
//! apparmor-prompting feature enabled inside of a VM that has been set up using the Makefile
//! targets outlined in the README of this repo.
//!
//! Creation of the SnapdSocketClient needs to be handled before spawning the test snap so that
//! polling `after` is correct to pick up the prompt.

#![cfg(not(feature = "dry-run"))]

use prompting_client::{
    Error, Result,
    cli_actions::ScriptedClient,
    prompt_sequence::MatchError,
    snapd_client::{
        Action, Lifespan, PromptId, PromptNotice, SnapdSocketClient, TypedPrompt,
        interfaces::{
            SnapInterface, camera::CameraInterface, home::HomeInterface,
            microphone::MicrophoneInterface,
        },
    },
};
use serial_test::serial;
use simple_test_case::test_case;
use std::{
    env, fs,
    io::{self, ErrorKind},
    os::unix::fs::PermissionsExt,
    process::Stdio,
    time::Duration,
};
use tokio::{
    process::Command,
    runtime::Runtime,
    spawn,
    task::JoinHandle,
    time::{sleep, timeout},
};
use uuid::Uuid;

const TEST_SNAP: &str = "aa-prompting-test";
const PROMPT_NOT_FOUND: &str = "cannot find prompt with the given ID for the given user";
const TIMEOUT: Duration = Duration::from_secs(65);

#[derive(Debug, Clone, PartialEq, Eq)]
struct Output {
    stdout: String,
    stderr: String,
}

struct TestFixture {
    path: Option<String>,
    prefix: Option<String>,
}

impl TestFixture {
    fn new() -> Self {
        Self {
            path: None,
            prefix: None,
        }
    }

    fn with_test_dir(subdir: Option<&str>, files: &[(&str, &str)]) -> io::Result<Self> {
        let prefix = Uuid::new_v4().to_string();
        let home = get_home();
        let path = match subdir {
            Some(s) => format!("{home}/test/{prefix}/{s}"),
            None => format!("{home}/test/{prefix}"),
        };

        fs::create_dir_all(&path)?;
        for (fname, contents) in files {
            let file_path = format!("{path}/{fname}");
            fs::write(&file_path, contents)?;

            // Set readable permissions for all files so eventually snaps can access them
            let mut perms = fs::metadata(&file_path)?.permissions();
            perms.set_mode(0o644); // rw-r--r-- (readable by all)
            fs::set_permissions(&file_path, perms)?;
        }

        let prefix = Some(prefix);
        let path = Some(path);

        Ok(Self { prefix, path })
    }

    fn path(&self) -> String {
        self.path
            .as_ref()
            .expect("path doesn't exist for this test")
            .clone()
    }

    fn prefix(&self) -> String {
        self.prefix
            .as_ref()
            .expect("prefix doesn't exist for this test")
            .clone()
    }

    fn spawn_for_output(&self, cmd: &'static str, args: Vec<String>) -> JoinHandle<Output> {
        spawn(async move {
            let mut c = Command::new(cmd);
            c.args(args)
                .stdout(Stdio::piped())
                .stderr(Stdio::piped())
                .kill_on_drop(true);

            let child = c.spawn().expect("spawn process");
            match timeout(TIMEOUT, child.wait_with_output()).await {
                Ok(Ok(output)) => Output {
                    stdout: String::from_utf8_lossy(&output.stdout).into_owned(),
                    stderr: String::from_utf8_lossy(&output.stderr).into_owned(),
                },
                Ok(Err(e)) => Output {
                    stdout: String::new(),
                    stderr: format!("Process exited with error: {e}"),
                },
                Err(_) => Output {
                    stdout: String::new(),
                    stderr: "Process timed out".to_string(),
                },
            }
        })
    }
}

impl Drop for TestFixture {
    fn drop(&mut self) {
        // The future is really blocking because `rt-multi-thread` is disabled in test.
        let _ = std::thread::spawn(|| {
            let rt = Runtime::new().expect("create cleanup runtime");

            // Some prompts can remain pending when testing errors, so we need to clean them up after the test
            rt.block_on(async {
                let c = SnapdSocketClient::new().await;

                let _ = timeout(Duration::from_secs(10), async {
                    // Answering prompts can unlock other prompts (like in create.sh),
                    // so we need multiple iterations to ensure all prompts are properly resolved.
                    while let Ok(pending) = c.all_pending_prompt_details().await
                        && !pending.is_empty()
                    {
                        for p in pending {
                            let id = p.id();
                            let reply = p.clone().into_deny_once();

                            let _ = c.reply_to_prompt(id, reply).await;
                        }

                        sleep(Duration::from_secs(1)).await;
                    }
                })
                .await;

                let pending = c.all_pending_prompt_details().await?;
                assert!(
                    pending.is_empty(),
                    "expected no pending prompts after clean up"
                );

                Ok::<(), Error>(())
            })
        })
        .join();
    }
}

fn get_home() -> String {
    env::var("HOME").expect("HOME env var to be set")
}

// We have this as a macro rather than a function so that we get the line numbers of the call site
// in test failures rather than the line numbers of the asserts within this helper
macro_rules! expect_single_prompt {
    ($c:expr, $expected_path:expr, $expected_permissions:expr) => {
        async {
            let pending = match timeout(TIMEOUT, $c.pending_prompt_notices()).await {
                Ok(pending) => pending,
                Err(_) => panic!("timeout reached while waiting for prompt"),
            };
            let mut pending: Vec<_> = match pending {
                Ok(pending) => pending
                    .into_iter()
                    .flat_map(|n| match n {
                        PromptNotice::Update(id) => Some(id),
                        _ => None,
                    })
                    .collect(),
                Err(e) => panic!("error pulling pending prompts: {e}"),
            };
            assert_eq!(pending.len(), 1, "expected a single prompt");

            let id = pending.remove(0);
            let p = match $c.prompt_details(&id).await {
                Ok(p) => p,
                Err(e) => panic!("error pulling prompt details: {e}"),
            };

            match &p {
                TypedPrompt::Camera(p) => {
                    assert_eq!(p.snap(), TEST_SNAP);
                    assert_eq!(p.requested_permissions(), $expected_permissions);
                }
                TypedPrompt::Home(p) => {
                    assert_eq!(p.snap(), TEST_SNAP);
                    assert_eq!(p.path(), $expected_path);
                    assert_eq!(p.requested_permissions(), $expected_permissions);
                }
                TypedPrompt::Microphone(p) => {
                    assert_eq!(p.snap(), TEST_SNAP);
                    assert_eq!(p.requested_permissions(), $expected_permissions);
                }
            }

            (id, p)
        }
    };
}

// Included as a test to help with identifying when the VM hasn't been set up correctly
#[tokio::test]
async fn ensure_prompting_is_enabled() -> Result<()> {
    let c = SnapdSocketClient::new().await;
    assert!(c.is_prompting_enabled().await?, "prompting is not enabled");

    Ok(())
}

#[test_case(Action::Allow, "Allow access to camera\n", ""; "allow")]
#[test_case(Action::Deny, "Deny access to camera\n", "Failed to open <DEVICE>: Permission denied\n"; "deny")]
#[tokio::test]
#[serial]
async fn camera_interface_connected(
    action: Action,
    expected_stdout: &str,
    expected_stderr: &str,
) -> Result<()> {
    let device = "/dev/video0";

    let test = TestFixture::new();
    let mut c = SnapdSocketClient::new().await;

    let rx = test.spawn_for_output("aa-prompting-test.camera", vec![device.into()]);
    let (id, p) = expect_single_prompt!(&mut c, "", &["access"]).await;

    c.reply_to_prompt(
        &id,
        CameraInterface::prompt_to_reply(p.try_into()?, action).into(),
    )
    .await?;

    let output = timeout(TIMEOUT, rx)
        .await
        .expect("to be able to recv")
        .expect("join to succeed");

    assert_eq!(output.stdout, expected_stdout, "stdout");
    assert_eq!(
        output.stderr,
        expected_stderr.replace("<DEVICE>", device),
        "stderr"
    );

    Ok(())
}

#[test_case(Action::Allow, "Allow access to <PATH>\n", ""; "allow")]
#[test_case(Action::Deny, "Deny access to <PATH>\n", "cat: <PATH>: Permission denied\n"; "deny")]
#[tokio::test]
#[serial]
async fn camera_interface_connected_naive(
    action: Action,
    expected_stdout: &str,
    expected_stderr: &str,
) -> Result<()> {
    let device = "/dev/video9"; // No test environments should have 10 camera devices

    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::new();

    let rx = test.spawn_for_output("aa-prompting-test.camera-naive", vec![device.into()]);
    let (id, p) = expect_single_prompt!(&mut c, "", &["access"]).await;

    c.reply_to_prompt(
        &id,
        CameraInterface::prompt_to_reply(p.try_into()?, action).into(),
    )
    .await?;

    let output = timeout(TIMEOUT, rx)
        .await
        .expect("to be able to recv")
        .expect("join to succeed");

    assert_eq!(
        output.stdout,
        expected_stdout.replace("<PATH>", device),
        "stdout"
    );
    assert_eq!(
        output.stderr,
        expected_stderr.replace("<PATH>", device),
        "stderr"
    );

    Ok(())
}

// TODO: remove ignore when support for `microphone` interface lands on snapd
#[ignore = "snapd doesn't have support for microphone prompt"]
#[test_case(Action::Allow, "Allow access to microphone\n", ""; "allow")]
#[test_case(Action::Deny, "Deny access to microphone\n", "timeout: failed to open <DEVICE>: Permission denied\n"; "deny")]
#[tokio::test]
#[serial]
async fn microphone_interface_connected(
    action: Action,
    expected_stdout: &str,
    expected_stderr: &str,
) -> Result<()> {
    let device = "hw:0,0"; // this is the alsa equivalent of /dev/snd/pcmC0D0c

    let test = TestFixture::new();
    let mut c = SnapdSocketClient::new().await;

    let rx = test.spawn_for_output("aa-prompting-test.microphone", vec![device.into()]);
    let (id, p) = expect_single_prompt!(&mut c, "", &["access"]).await;

    c.reply_to_prompt(
        &id,
        MicrophoneInterface::prompt_to_reply(p.try_into()?, action).into(),
    )
    .await?;

    let output = timeout(TIMEOUT, rx)
        .await
        .expect("to be able to recv")
        .expect("join to succeed");

    assert_eq!(output.stdout, expected_stdout, "stdout");
    assert_eq!(
        output.stderr,
        expected_stderr.replace("<DEVICE>", device),
        "stderr"
    );

    Ok(())
}

#[test_case(Action::Allow, "testing testing 1 2 3\n", ""; "allow")]
#[test_case(Action::Deny, "", "cat: <HOME>/test/<PATH>/test.txt: Permission denied\n"; "deny")]
#[tokio::test]
#[serial]
async fn happy_path_read_single(
    action: Action,
    expected_stdout: &str,
    expected_stderr: &str,
) -> Result<()> {
    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("test.txt", expected_stdout)])?;

    let rx = test.spawn_for_output("aa-prompting-test.read", vec![test.prefix()]);
    let (id, p) =
        expect_single_prompt!(&mut c, &format!("{}/test.txt", test.path()), &["read"]).await;

    c.reply_to_prompt(
        &id,
        HomeInterface::prompt_to_reply(p.try_into()?, action).into(),
    )
    .await?;
    let output = timeout(TIMEOUT, rx)
        .await
        .expect("to be able to recv")
        .expect("join to succeed");

    assert_eq!(output.stdout, expected_stdout, "stdout");
    assert_eq!(
        output.stderr,
        expected_stderr
            .replace("<HOME>", &get_home())
            .replace("<PATH>", &test.prefix()),
        "stderr"
    );

    Ok(())
}

#[test_case(Action::Allow, Lifespan::Session; "allow session")]
#[test_case(Action::Deny, Lifespan::Session; "deny session")]
#[test_case(Action::Allow, Lifespan::Timespan; "allow timespan")]
#[test_case(Action::Allow, Lifespan::Forever; "allow forever")]
#[test_case(Action::Deny, Lifespan::Timespan; "deny timespan")]
#[test_case(Action::Deny, Lifespan::Forever; "deny forever")]
#[tokio::test]
#[serial]
async fn happy_path_create_multiple(action: Action, lifespan: Lifespan) -> Result<()> {
    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[])?;

    let _rx = test.spawn_for_output("aa-prompting-test.create", vec![test.prefix()]);
    let path = format!("{}/test-1.txt", test.path());
    let (id, p) = expect_single_prompt!(&mut c, &path, &["write"]).await;
    let mut reply = HomeInterface::prompt_to_reply(p.try_into()?, action)
        .with_custom_path_pattern(format!("{}/*", test.path()));

    reply = match lifespan {
        Lifespan::Timespan => reply.for_timespan("1s"),
        Lifespan::Session => reply.for_session(),
        Lifespan::Forever => reply.for_forever(),
        Lifespan::Single => {
            panic!("SETUP ERROR: this test requires actioning multiple prompts with a single reply")
        }
    };

    c.reply_to_prompt(&id, reply.into()).await?;

    sleep(Duration::from_millis(50)).await;

    let files = &[
        ("test-1.txt", "test\n"),
        ("test-2.txt", "test\n"),
        ("test-3.txt", "test\n"),
    ];

    for (p, s) in files {
        let res = fs::read_to_string(format!("{}/{p}", test.path()));
        match action {
            Action::Allow => assert_eq!(res.expect("file should exist"), *s),
            Action::Deny => assert_eq!(
                res.expect_err(&format!("file {p} should not exist")).kind(),
                ErrorKind::NotFound
            ),
        }
    }

    Ok(())
}

#[ignore = "snapd parks the second process for 60s before generating the prompt so this is slow"]
#[test_case(Action::Allow, Lifespan::Timespan; "allow timespan")]
#[test_case(Action::Allow, Lifespan::Forever; "allow forever")]
#[test_case(Action::Deny, Lifespan::Timespan; "deny timespan")]
#[test_case(Action::Deny, Lifespan::Forever; "deny forever")]
#[tokio::test]
#[serial]
async fn create_multiple_actioned_by_other_pid(action: Action, lifespan: Lifespan) -> Result<()> {
    let test = TestFixture::with_test_dir(None, &[])?;

    let _rx = test.spawn_for_output("aa-prompting-test.create", vec![test.prefix()]);
    sleep(Duration::from_millis(400)).await;

    let mut c = SnapdSocketClient::new().await;

    let _rx = test.spawn_for_output(
        "aa-prompting-test.create-single",
        vec![test.prefix(), "test\n".to_string()],
    );

    let path = format!("{}/test.txt", test.prefix());
    let (id, p) = expect_single_prompt!(&mut c, &path, &["write"]).await;
    let mut reply = HomeInterface::prompt_to_reply(p.try_into()?, action)
        .with_custom_path_pattern(format!("{}/*", test.prefix()));

    reply = match lifespan {
        Lifespan::Timespan => reply.for_timespan("1s"),
        Lifespan::Session => reply.for_session(),
        Lifespan::Forever => reply.for_forever(),
        Lifespan::Single => {
            panic!("SETUP ERROR: this test requires actioning multiple prompts with a single reply")
        }
    };

    // Replying to the prompt from create-single while the original create process is hung waiting
    // for its prompt to be actioned. The rule we create here should action that prompt and then
    // create a rule that handles the remaining two writes without prompting.
    c.reply_to_prompt(&id, reply.into()).await?;
    sleep(Duration::from_millis(50)).await;

    let files = &[
        ("test-1.txt", "test\n"),
        ("test-2.txt", "test\n"),
        ("test-3.txt", "test\n"),
    ];

    for (p, s) in files {
        let res = fs::read_to_string(format!("{}/{p}", test.path()));
        match action {
            Action::Allow => assert_eq!(res.expect("file should exist"), *s),
            Action::Deny => assert_eq!(
                res.expect_err(&format!("file {p} should not exist")).kind(),
                ErrorKind::NotFound
            ),
        }
    }

    Ok(())
}

#[tokio::test]
#[serial]
async fn requesting_an_unknown_prompt_id_is_an_error() -> Result<()> {
    let c = SnapdSocketClient::new().await;
    let res = c
        .prompt_details(&PromptId("0123456789ABCDEF".to_string()))
        .await;

    match res {
        Err(Error::SnapdError { message, .. }) => {
            assert_eq!(message, PROMPT_NOT_FOUND, "unexpected message")
        }
        Err(e) => panic!("expected a snapd error, got: {e}"),
        Ok(p) => panic!("expected an error, got {p:?}"),
    }

    Ok(())
}

#[test_case("not a valid custom path!", "cannot decode request body into prompt reply: invalid path pattern: pattern must start with"; "malformed path")]
#[test_case("/home/bob/*", "path pattern in reply constraints does not match originally requested path"; "invalid path")]
#[tokio::test]
#[serial]
async fn incorrect_custom_paths_error(reply_path: &str, expected_prefix: &str) -> Result<()> {
    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("test.txt", "test")])?;

    let _rx = test.spawn_for_output("aa-prompting-test.read", vec![test.prefix()]);
    let (id, p) =
        expect_single_prompt!(&mut c, &format!("{}/test.txt", test.path()), &["read"]).await;
    let reply = HomeInterface::prompt_to_reply(p.try_into()?, Action::Allow)
        .with_custom_path_pattern(reply_path)
        .into();

    match c.reply_to_prompt(&id, reply).await {
        Err(Error::SnapdError { message, .. }) => assert!(
            message.starts_with(expected_prefix),
            "message format not as expected: {message:?}"
        ),
        Err(e) => panic!("expected a snapd error, got: {e:?}"),
        Ok(_) => panic!("should have errored but got an OK response"),
    }

    Ok(())
}

#[test_case("9d", "cannot parse duration: time: unknown unit"; "unknown unit")]
#[test_case("foo", "cannot parse duration: time: invalid duration"; "invalid duration")]
#[test_case("5", "cannot parse duration: time: missing unit in duration"; "missing units")]
#[test_case("0s", "cannot have zero or negative duration"; "zero value")]
#[test_case("-12s", "cannot have zero or negative duration"; "negative value")]
// 9223372036854775807 is i64::MAX https://pkg.go.dev/time#Duration
#[test_case("9223372037s", "cannot parse duration: time: invalid duration"; "overflow")]
#[tokio::test]
#[serial]
async fn invalid_timeperiod_duration_errors(timespan: &str, expected_prefix: &str) -> Result<()> {
    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("test.txt", "test")])?;

    let _rx = test.spawn_for_output("aa-prompting-test.read", vec![test.prefix()]);
    let (id, p) =
        expect_single_prompt!(&mut c, &format!("{}/test.txt", test.path()), &["read"]).await;
    let reply = HomeInterface::prompt_to_reply(p.try_into()?, Action::Allow)
        .for_timespan(timespan)
        .into();

    match c.reply_to_prompt(&id, reply).await {
        Err(Error::SnapdError { message, .. }) => assert!(
            message.starts_with(&format!(
                "cannot decode request body into prompt reply: invalid duration: {expected_prefix}"
            )),
            "message format not as expected: {message}"
        ),
        Err(e) => panic!("expected a snapd error, got: {e}"),
        Ok(_) => panic!("should have errored but got an OK response"),
    }

    Ok(())
}

#[test_case(Action::Allow, "testing testing 1 2 3\n", ""; "allow")]
#[test_case(Action::Deny, "", "cat: <HOME>/test/<PATH>/test.txt: Permission denied\n"; "deny")]
#[tokio::test]
#[serial]
async fn replying_multiple_times_errors(
    action: Action,
    expected_stdout: &str,
    expected_stderr: &str,
) -> Result<()> {
    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("test.txt", expected_stdout)])?;

    let rx = test.spawn_for_output("aa-prompting-test.read", vec![test.prefix()]);
    let (id, p) =
        expect_single_prompt!(&mut c, &format!("{}/test.txt", test.path()), &["read"]).await;

    let p: prompting_client::snapd_client::Prompt<HomeInterface> = p.try_into()?;

    // first reply should work fine
    c.reply_to_prompt(
        &id,
        HomeInterface::prompt_to_reply(p.clone(), action).into(),
    )
    .await?;
    let output = timeout(TIMEOUT, rx)
        .await
        .expect("to be able to recv")
        .expect("join to succeed");

    assert_eq!(output.stdout, expected_stdout, "stdout");
    assert_eq!(
        output.stderr,
        expected_stderr
            .replace("<HOME>", &get_home())
            .replace("<PATH>", &test.prefix()),
        "stderr"
    );

    // second reply should error because the prompt no longer exists in snapd
    let res = c
        .reply_to_prompt(
            &id,
            HomeInterface::prompt_to_reply(p.clone(), action).into(),
        )
        .await;

    match res {
        Err(Error::SnapdError { message, .. }) => {
            assert_eq!(message, PROMPT_NOT_FOUND, "unexpected message")
        }
        Err(e) => panic!("expected a snapd error, got: {e}"),
        Ok(p) => panic!("expected an error, got {p:?}"),
    }

    Ok(())
}

#[tokio::test]
#[serial]
async fn overwriting_a_file_works() -> Result<()> {
    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[])?;

    let rx = test.spawn_for_output(
        "aa-prompting-test.create-single",
        vec![test.prefix(), "before".to_string()],
    );
    let (id, p) =
        expect_single_prompt!(&mut c, &format!("{}/test.txt", test.path()), &["write"]).await;
    let reply = HomeInterface::prompt_to_reply(p.try_into()?, Action::Allow)
        .for_forever()
        .into();
    c.reply_to_prompt(&id, reply).await?;
    sleep(Duration::from_millis(50)).await;

    // The file should have been created and contain the correct content
    let res = fs::read_to_string(format!("{}/test.txt", test.path()));
    assert_eq!(res.expect("file should exist"), "before");

    // Not expecting another prompt due to previous allow always reply
    let _rx = test.spawn_for_output(
        "aa-prompting-test.create-single",
        vec![test.prefix(), "after".to_string()],
    );
    sleep(Duration::from_millis(300)).await;
    let output = timeout(TIMEOUT, rx)
        .await
        .expect("to be able to recv")
        .expect("join to succeed");
    assert_eq!(output.stdout, "done\n");
    assert_eq!(output.stderr, "");

    // The file should now contain the updated content
    let res = fs::read_to_string(format!("{}/test.txt", test.path()));
    assert_eq!(res.expect("file should exist"), "after");

    Ok(())
}

#[tokio::test]
#[serial]
async fn scripted_client_works_with_simple_matching() -> Result<()> {
    let seq = include_str!("../resources/prompt-sequence-tests/e2e_write_test.json");

    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("seq.json", seq)])?;

    let _rx = test.spawn_for_output("aa-prompting-test.create", vec![test.prefix()]);

    let mut scripted_client = ScriptedClient::try_new(
        format!("{}/seq.json", test.path()),
        &[("BASE_PATH", &test.path())],
        c.clone(),
    )?;

    let res = scripted_client
        .run_with_timeout(&mut c, None, TIMEOUT)
        .await;
    sleep(Duration::from_millis(50)).await;

    if let Err(e) = res {
        panic!("unexpected error running scripted client: {e}");
    }

    let files = &[
        ("test-1.txt", "test\n"),
        ("test-2.txt", "test\n"),
        ("test-3.txt", "test\n"),
    ];

    for (p, s) in files {
        let res = fs::read_to_string(format!("{}/{p}", test.path()));
        assert_eq!(res.expect("file should exist"), *s);
    }

    Ok(())
}

#[tokio::test]
#[serial]
async fn invalid_prompt_sequence_reply_errors() -> Result<()> {
    let seq = include_str!("../resources/prompt-sequence-tests/e2e_erroring_write_test.json");

    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("seq.json", seq)])?;

    let _rx = test.spawn_for_output("aa-prompting-test.create", vec![test.prefix()]);

    let mut scripted_client = ScriptedClient::try_new(
        format!("{}/seq.json", test.path()),
        &[("BASE_PATH", &test.path())],
        c.clone(),
    )?;

    match scripted_client
        .run_with_timeout(&mut c, None, TIMEOUT)
        .await
    {
        Err(Error::FailedPromptSequence {
            error: MatchError::UnexpectedError { error },
        }) => {
            assert!(
                error.starts_with(
                    "path pattern in reply constraints does not match originally requested path"
                ),
                "{error}"
            );
        }
        Err(e) => panic!("unexpected error: {e}"),
        Ok(()) => panic!("expected client to error but it ran to completion"),
    }

    Ok(())
}

#[tokio::test]
#[serial]
async fn unexpected_prompt_in_sequence_errors() -> Result<()> {
    let seq = include_str!("../resources/prompt-sequence-tests/e2e_wrong_path_test.json");

    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("seq.json", seq)])?;

    let _rx = test.spawn_for_output("aa-prompting-test.create", vec![test.prefix()]);
    let mut scripted_client = ScriptedClient::try_new(
        format!("{}/seq.json", test.path()),
        &[("BASE_PATH", &test.path())],
        c.clone(),
    )?;

    match scripted_client
        .run_with_timeout(&mut c, None, TIMEOUT)
        .await
    {
        Err(Error::FailedPromptSequence {
            error: MatchError::MatchFailures { index, failures },
        }) => {
            assert_eq!(index, 1);
            assert_eq!(failures[0].field, "path");
            assert_eq!(failures[1].field, "requested_permissions");
        }
        Err(e) => panic!("unexpected error: {e}"),
        Ok(()) => panic!("expected client to error but it ran to completion"),
    }

    Ok(())
}

#[tokio::test]
#[serial]
async fn prompt_after_a_sequence_with_grace_period_errors() -> Result<()> {
    let seq = include_str!(
        "../resources/prompt-sequence-tests/e2e_unexpected_additional_prompt_test.json"
    );

    let mut c = SnapdSocketClient::new().await;
    let test = TestFixture::with_test_dir(None, &[("seq.json", seq)])?;

    let _rx = test.spawn_for_output("aa-prompting-test.create", vec![test.prefix()]);
    let mut scripted_client = ScriptedClient::try_new(
        format!("{}/seq.json", test.path()),
        &[("BASE_PATH", &test.path())],
        c.clone(),
    )?;

    match scripted_client
        .run_with_timeout(&mut c, Some(5), TIMEOUT)
        .await
    {
        Err(Error::FailedPromptSequence {
            error: MatchError::UnexpectedPrompts { .. },
        }) => (),
        Err(e) => panic!("unexpected error: {e}"),
        Ok(()) => panic!("expected client to error but it ran to completion"),
    }

    Ok(())
}

#[tokio::test]
#[serial]
async fn prompt_after_a_sequence_without_grace_period_is_ok() -> Result<()> {
    let seq = include_str!(
        "../resources/prompt-sequence-tests/e2e_unexpected_additional_prompt_test.json"
    );
    let test = TestFixture::with_test_dir(None, &[("seq.json", seq)])?;

    let mut c = SnapdSocketClient::new().await;

    let _rx = test.spawn_for_output("aa-prompting-test.create", vec![test.prefix()]);
    let mut scripted_client = ScriptedClient::try_new(
        format!("{}/seq.json", test.path()),
        &[("BASE_PATH", &test.path())],
        c.clone(),
    )?;

    if let Err(e) = scripted_client
        .run_with_timeout(&mut c, None, TIMEOUT)
        .await
    {
        panic!("unexpected error: {e}")
    }

    Ok(())
}

#[tokio::test]
#[serial]
async fn scripted_client_test_allow() -> Result<()> {
    let script = include_str!("../resources/scripted-tests/happy-path-read/test.sh");
    let seq = include_str!("../resources/scripted-tests/happy-path-read/prompt-sequence.json");

    let test = TestFixture::with_test_dir(
        None,
        &[
            ("test.txt", "testing testing 1 2 3"),
            ("test.sh", script),
            ("prompt-sequence.json", seq),
        ],
    )?;

    let script_path = format!("{}/test.sh", test.path());
    let file = fs::File::open(&script_path)?;
    let mut perms = file.metadata()?.permissions();
    perms.set_mode(perms.mode() | 0o111); // Set executable bit for all users (chmod +x)
    file.set_permissions(perms)?;

    let res = Command::new(script_path)
        .args([test.prefix()])
        .spawn()
        .expect("script to start")
        .wait()
        .await;

    let exit_status = res.expect("process to exit");
    if !exit_status.success() {
        panic!("test failed: {exit_status}");
    }

    Ok(())
}
