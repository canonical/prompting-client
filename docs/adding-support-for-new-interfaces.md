# Adding support for new Snapd interfaces

This document outlines the process for adding support for new [Snapd interfaces](https://snapcraft.io/docs/supported-interfaces) to the prompting client. The implementation follows a modular approach where each interface has its own dedicated module with specific types and logic.

## Parsing and handling the new prompt type

Creating support for a new interface begins with establishing a dedicated Rust module in `prompting-client/src/snapd_client/interfaces/` following the naming pattern `{interface_name}.rs`. This module serves as the foundation for all interface-specific logic and must implement the `SnapInterface` trait along with several associated types that define how the interface handles constraints, replies, filtering, and UI interaction.

The core types required include:

- `Constraints` for the interface's permission structure
- `ReplyConstraints` for reply-specific data
- `ConstraintsFilter` for scripted client filtering logic
- `ReplyConstraintsOverrides` for scripted response customization
- `UiInputData` for UI communication
- `UiReplyConstraints` for protobuf-generated reply types

Here's an example of implementing the camera interface structure:

```rust
#[derive(Debug, Default, Clone, Deserialize, Serialize, PartialEq, Eq)]
pub struct CameraInterface;

impl SnapInterface for CameraInterface {
    const NAME: &'static str = "camera";

    type Constraints = CameraConstraints;
    type ReplyConstraints = CameraReplyConstraints;
    type ConstraintsFilter = CameraConstraintsFilter;
    type ReplyConstraintsOverrides = CameraReplyConstraintsOverrides;
    type UiInputData = CameraUiInputData;
    type UiReplyConstraints = CameraPromptReply;

    fn prompt_to_reply(prompt: Prompt<Self>, action: Action) -> PromptReply<Self> {
        PromptReply {
            action,
            lifespan: Lifespan::Single,
            duration: None,
            constraints: CameraReplyConstraints {
                permissions: prompt.constraints.requested_permissions,
                available_permissions: prompt.constraints.available_permissions,
            },
        }
    }
}
```

The constraints structure defines the permission model for the interface:

```rust
#[derive(Default, Debug, Clone, PartialEq, Eq, Deserialize, Serialize)]
#[serde(rename_all = "kebab-case")]
pub struct CameraConstraints {
    pub(crate) requested_permissions: Vec<String>,
    pub(crate) available_permissions: Vec<String>,
}
```

Once the module is created, the interfaces module at `prompting-client/src/snapd_client/interfaces/mod.rs` must be updated to include the new interface. This involves adding a public module declaration, extending the `TypedPrompt` and `TypedPromptReply` enums with the new interface variant, and updating all relevant pattern matching throughout the codebase.

The interface implementation centers around several key methods that handle the core functionality. The `prompt_to_reply()` method converts incoming prompts to replies for the scripted client, while `ui_input_from_prompt()` transforms prompts into UI-ready data structures. The `proto_prompt_from_ui_input()` method handles conversion to protobuf format for communication with the Flutter UI, and `map_proto_reply_constraints()` parses constraint data from UI responses back into Rust types.

## Updating the GRPC API

The protobuf definition in `protos/apparmor-prompting.proto` requires updates to accommodate the new interface. This involves creating new message types for both the prompt and reply structures, such as `CameraPrompt` and `CameraPromptReply`, along with any interface-specific enums like `DevicePermission`. These new messages must then be integrated into the existing `oneof` unions within the `Prompt` and `PromptReply` messages to maintain the polymorphic structure of the API.

For the camera interface, the protobuf additions include:

```protobuf
enum DevicePermission {
    ACCESS = 0;
}

message CameraPrompt {
    MetaData meta_data = 1;
}

message CameraPromptReply {
    repeated DevicePermission permissions = 1;
}

message GetCurrentPromptResponse {
    oneof prompt {
        HomePrompt home_prompt = 1;
        CameraPrompt camera_prompt = 2;  // Add here
    }
}

message PromptReply {
    string prompt_id = 1;
    Action action = 2;
    Lifespan lifespan = 3;
    oneof prompt_reply {
        HomePromptReply home_prompt_reply = 4;
        CameraPromptReply camera_prompt_reply = 5;  // Add here
    }
}
```

After modifying the protobuf definition, running `cargo build` automatically regenerates the Rust protobuf bindings in `prompting-client/src/protos/`, ensuring that all the new types are available throughout the Rust codebase. The daemon code also requires updates to handle the new prompt type in both the polling logic that receives prompts from snapd and the response processing that sends replies back.

## Supporting the new interface in the UI

### Regenerating the protobuf generated files

You can use `Melos` to update the Flutter proto stubs using:
```
melos run protoc
```
Which will update the generated files in `packages/prompting_client/lib/src/generated`.

### Create a new directory in `/pages` for the new interface

Each supported interface has a respective folder in `apps/prompting_client_ui/lib/pages`, which represents the UI that will be shown when a prompt of that interface type is invoked by the Rust client.

To support a new interface, you will need to add a new directory for the interface. As we are making use of `Riverpod`, you will typically need:
- `<new-interface>_prompt_page.dart` for the UI widgets used to build your page, as well as the main `<new-interface>PromptPage` widget that will be called to display the new interfaces prompt.
- `<new-interface>_prompt_error.dart` for error enums specific to the interface
- `<new-interface>_prompt_data_model.dart` for the data models and [providers](https://riverpod.dev/docs/concepts2/providers)
### Adding the new interface to the `prompt_page` switch statement.
In `apps/prompting_client_ui/lib/page` is the `prompting_page.dart` file, which contains the switch statement that is used to determine which prompt page to show. You will need to add the new interface to this statement, pointing it to the relevant `<new-interface>PromptPage` widget.
```dart
return SizeChangedLayoutNotifier(
  child: ConstrainedBox(
	constraints: const BoxConstraints(minWidth: 560),
	child: Padding(
	  padding: const EdgeInsets.all(18.0),
	  child: switch (prompt) {
		PromptDetailsHome() => const HomePromptPage(),
		PromptDetailsCamera() => const CameraPromptPage(),
		PromptDetailsMicrophone() => const MicrophonePromptPage(),
		// TODO: New interface goes here.
	  },
	),
  ),
```

### Updating the `fake_prompting_client`
The tests are based on the mock client in `apps/prompting_client_ui/lib/fake_prompting_client.dart`. You will need to add a case statement for the interface in the `replyToPrompt()` method.
```dart
@override
Future<PromptReplyResponse> replyToPrompt(PromptReply reply) async {
_log.info('replyToPrompt: $reply');
onReply?.call(reply);

switch (reply) {
  case PromptReplyHome(:final pathPattern):
	// This regex checks whether the provided path starts with a `/` and does
	// not contain any `[` or `]` characters. (Same check that snapd does
	// internally)
	final validPattern = RegExp(r'^/([^\[\]]|\\[\[\]])*$');
	if (!validPattern.hasMatch(pathPattern)) {
	  _log.info('invalid home pattern');
	  return PromptReplyResponse.unknown(message: 'invalid pattern');
	}
	_log.info('valid home pattern');
	return PromptReplyResponse.success();

  case PromptReplyCamera():
	return PromptReplyResponse.success();

  case PromptReplyMicrophone():
	return PromptReplyResponse.success();
	
  // TODO: new interface goes here
}
}
```

From here, you have what you need to add unit tests to `apps/test/<new-interface>`.
## Supporting the new interface in the scripted client

The scripted client requires updates to support new interfaces. While the binary in `prompting-client/src/bin/scripted.rs` doesn't require changes, the core logic in `prompting-client/src/prompt_sequence.rs` must be updated.

The required changes include adding the new interface to:

- `TypedPromptCase` enum for test case handling
- `TypedPromptFilter` enum for filtering logic
- Pattern matching in `try_match_next()` method
- Filter matching in `TypedPromptFilter::matches()`

These updates enable the scripted client to deserialize test scripts containing the new interface and properly match incoming prompts against expected test cases for automated testing scenarios.

## Support the new interface in the mock server

In order to keep the mock server in sync with the client, we need to add a new fake prompt to the `/mock-server/prompts/` directory. It will be automatically tested with integration tests.

The `interface` and `constraints` fields must be filled with the defined `NAME` and `Constraints` respectively, based on the specifications.

For the camera interface, a possible prompt looks like:

```json
{
    "id": "0000000000000000",
    "timestamp": "2025-08-20T16:17:44.28198468+02:00",
    "snap": "cheese",
    "pid": 136211,
    "cgroup": "/user.slice/user-1000.slice/user@1000.service/app.slice/cheese.scope",
    "interface": "camera",
    "constraints": {
        "requested-permissions": [
            "access"
        ],
        "available-permissions": [
            "access"
        ]
    }
}
```

## Testing

Comprehensive testing forms a critical part of interface implementation, encompassing both unit and integration testing strategies. Unit tests within the interface module should cover prompt deserialization from JSON, prompt-to-reply conversion logic, custom permission validation, and constraints filtering functionality. These tests ensure that the core interface logic works correctly in isolation.

Here's an example of unit tests for the camera interface:

```rust
const CAMERA_PROMPT: &str = r#"{
  "id": "C7OUCCDWCE6CC===",
  "timestamp": "2024-06-28T19:15:37.321782305Z",
  "snap": "firefox",
  "pid": 1234,
  "interface": "camera",
  "constraints": {
    "requested-permissions": ["access"],
    "available-permissions": ["access"]
  }
}"#;

#[test]
fn deserializing_a_camera_prompt_works() {
    let raw: RawPrompt = serde_json::from_str(CAMERA_PROMPT).unwrap();
    assert_eq!(raw.interface, "camera");

    let p: TypedPrompt = raw.try_into().unwrap();
    assert!(matches!(p, TypedPrompt::Camera(_)));
}

#[test_case(&["allow"], &["allow", "read"]; "some not in available")]
#[test_case(&["allow"], &["write"]; "none in available")]
#[test]
fn invalid_reply_permissions_error(available: &[&str], requested: &[&str]) {
    let reply: PromptReply<CameraInterface> = PromptReply {
        constraints: CameraReplyConstraints {
            available_permissions: available.iter().map(|&s| s.into()).collect(),
            ..Default::default()
        },
        ..Default::default()
    };

    let res = reply.try_with_custom_permissions(requested.iter().map(|&s| s.into()).collect());
    match res {
        Err(Error::InvalidCustomPermissions { .. }) => (),
        Err(e) => panic!("expected InvalidCustomPermissions, got {e}"),
        Ok(_) => panic!("should have errored"),
    }
}
```

Integration testing takes place in `prompting-client/tests/integration.rs` and involves actual interaction with a running snapd instance. These tests verify that the complete flow works correctly, from receiving prompts through sending replies, testing both allow and deny actions. The integration tests use the test snap to trigger real prompts and validate the expected stdout and stderr output from the test applications.

Example integration test for camera:

```rust
#[test_case(Action::Allow, "Allow access to camera\n", ""; "allow")]
#[test_case(Action::Deny, "Deny access to camera\n", "Failed to open <DEVICE>: Permission denied\n"; "deny")]
#[tokio::test]
#[serial]
async fn camera_interface_connected(
    action: Action,
    expected_stdout: &str,
    expected_stderr: &str,
) -> Result<()> {
    let mut c = SnapdSocketClient::new().await;
    let device = "/dev/video0";

    let rx = spawn_for_output("aa-prompting-test.camera", vec![device.into()]);
    let (id, p) = expect_single_prompt!(&mut c, "", &["access"]).await;

    c.reply_to_prompt(
        &id,
        CameraInterface::prompt_to_reply(p.try_into()?, action).into(),
    )
    .await?;

    let output = rx.recv().expect("to be able to recv");

    assert_eq!(output.stdout, expected_stdout, "stdout");
    assert_eq!(
        output.stderr,
        expected_stderr.replace("<DEVICE>", &device),
        "stderr"
    );

    Ok(())
}
```

Supporting test infrastructure includes creating test scripts in `testing-snap/scripts/` that exercise the interface functionality. Each script should perform an operation that triggers a notice from snapd, based on the AppArmor rule for the interface.

For the camera interface, this script attempts to access the `/dev/video0` device, which is protected by the AppArmor rule `prompt /dev/video[0-9]* rw`:

```bash
#!/usr/bin/env sh

set -eu

device="$1"

if v4l2-ctl --device=$device --info > /dev/null 2>&1; then
    echo "Allow access to camera"
else
    echo "Deny access to camera"
fi
```

Testing follows established patterns, using `#[test_case]` for parameterized tests and `#[serial]` for integration tests that interact with snapd. Both successful and error scenarios should be tested to ensure proper error handling and messaging throughout the system.

If needed, utility tools can be added to the snap enviroment via the `snapcraft.yaml` file:

```yaml
parts:
    scripts:
        plugin: dump
        source: scripts/
        stage-packages:
            - v4l-utils  # for v4l2-ctl
```

## Supporting rule management in the Security Center

TODO
