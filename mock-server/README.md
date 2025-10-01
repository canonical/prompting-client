# Mock Server

This mock server is designed to facilitate the development and testing of the prompting client by mimicking the APIs and behaviors of snapd.

## Main Features

- Exposes endpoints for managing and simulating prompts.
- Allows testing of the client without relying on real external services.
- Loads initial pending prompts from the `prompts/` directory.

# API

## GET `/v2/notices`

This endpoint mimics the snapd [long polling](https://snapcraft.io/docs/snapd-api#heading--notices) API. To simulate this behavior, data is provided by the user through a UNIX pipe: the client waits until new notices are present, the user passes a prompt they want to test in JSON format, and the server converts the prompt into a notice and sends it to the client.

Example of a prompt with the `home` interface:

```json
{
    "id": "0000000000000001",
    "timestamp": "2025-08-20T14:32:06.330766685+02:00",
    "snap": "yq",
    "pid": 91995,
    "interface": "home",
    "constraints": {
        "path": "/home/foo.yaml",
        "requested-permissions": [
            "read"
        ],
        "available-permissions": [
            "read",
            "write",
            "execute"
        ]
    }
}
```

Example of a notice for the prompt above:

```json
[
    {
      "expire-after": "168h0m0s",
      "first-occurred": "2025-08-26T09:06:40.916344946Z",
      "id": "1",
      "key": "0000000000000001",
      "last-occurred": "2025-08-26T09:06:40.916344946Z",
      "last-repeated": "2025-08-26T09:06:40.916344946Z",
      "occurrences": 1,
      "type": "interfaces-requests-prompt",
      "user-id": 1000
    }
]
```

When the user replies to a prompt via the `/v2/interfaces/requests/prompts/{id}` endpoint, the notice is updated and sent with a new `last-data` field:

```json
[
    {
      "expire-after": "168h0m0s",
      "first-occurred": "2025-08-26T09:06:40.916344946Z",
      "id": "1",
      "key": "0000000000000001",
      "last-data": {
        "resolved": "replied"
      },
      "last-occurred": "2025-08-26T09:06:40.916344946Z",
      "last-repeated": "2025-08-26T09:06:40.916344946Z",
      "occurrences": 1,
      "type": "interfaces-requests-prompt",
      "user-id": 1000
    }
]
```

### Notes

- The `id` fields are unique for each prompt/notice and are assigned by the server.
- The notice's `key` field matches the prompt's `id` field.

## GET `/v2/interfaces/requests/prompts`

This endpoint returns the list of currently pending prompts that the mock server has loaded or received. It is useful for inspecting which prompts are awaiting user action or client processing.

The response is a JSON array, where each item represents a prompt object. Example:

```json
[
    {
        "id": "0000000000000001",
        "timestamp": "2025-08-20T14:35:00.123456789+02:00",
        "snap": "yq",
        "pid": 91995,
        "interface": "home",
        "constraints": {
            "path": "/home/foo.yaml",
            "requested-permissions": [
                "read"
            ],
            "available-permissions": [
                "read",
                "write",
                "execute"
            ]
        }
    }
]
```

## GET `/v2/interfaces/requests/prompts/{id}`

Returns a single prompt with the specified `id`.

### Note

- The `id` parameter is a **hexadecimal string** that matches a prompt in the internal server state.

## POST `/v2/interfaces/requests/prompts/{id}`

This endpoint mimics the [interface](https://snapcraft.io/docs/snapd-api#heading--interfaces) API. When the user replies to the prompt, it is removed from the internal server state. The request is printed to stdout by the server, and an updated notice is sent through the pipe.

Example of a POST request:

```json
{
    "action": "allow",
    "lifespan": "single",
    "constraints": {
        "path-pattern": "/home/**",
        "permissions": ["read", "write"]
    }
}
```

## GET `/v2/snaps/{snapname}`

Returns fake snap metadata.

Example response:

```json
{
    "install-date": "2025-08-08T09:15:01.505417578+02:00",
    "publisher": {
        "display-name": "foo"
    }
}
```

## GET `/v2/system-info`

Reports that the apparmor-prompting feature is enabled.

Example response:

```json
{
    "features": {
        "apparmor-prompting": {
            "supported": true,
            "enabled": true
        }
    }
}
```

## Usage Example

The mock server needs the `PIPE_PATH` and `SOCKET_PATH` environment variables to work properly.

For example:

```sh
cd mock-server
PIPE_PATH=/tmp/pipe SOCKET_PATH=/tmp/mock.sock cargo run
```

The `SOCKET_PATH` must match the value passed to the prompting-client instance you want to test. Additionally, you need to set other override environment variables for the client in order to test it standalone:

```sh
cd prompting-client
FLUTTER_UI_OVERRIDE=/path/to/ui/bin PROMPTING_CLIENT_SOCKET=/tmp/test.sock SNAPD_SOCKET_OVERRIDE=/tmp/mock.sock SNAP_REAL_HOME=/path/to/home cargo run --bin prompting-client-daemon --features dry-run
```

`FLUTTER_UI_OVERRIDE` can point to the production UI snap at `/snap/prompting-client/current/bin/prompting_client_ui` or to the one built in the `flutter/build` folder.

To simulate long polling behavior, you need to pass data through the pipe. Several mock prompts are available in the `prompts/` folder. For example, you can spawn a new `firefox` prompt with:

```sh
cat -p prompts/firefox.json > /tmp/pipe
```
