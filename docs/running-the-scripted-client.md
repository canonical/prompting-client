# The scripted prompting client

To aid with writing automated tests against `snapd`, the prompting client
provided in this repo can be run in a scripted mode. Doing so requires writing
a prompt sequence file specifying the prompts that expected to be seen and how
they should be actioned.

## Running the scripted client from the command line

The scripted client can be invoked using the `scripted` subcommand as shown below:

```bash
$ apparmor-prompting.scripted \
  --script my-script.json \
  --var "MY_VAR:foo" \
  --var "MY_OTHER_VAR:bar"
```

The JSON script file provided as an argument must parse as a valid prompt
sequence as outlined in the following section. The client will then
automatically reply to prompts using the provided sequence, exiting 0 exit code
if the sequence completes successfully and exiting non-0 if there are any
errors.

# Writing a prompt sequence

A prompt sequence is a simple JSON file with the following structure:

```json
{
  "version": 1,
  "prompt-filter": {
    "snap": "snap-name",
    "interface": "home",
    "constraints": {
      "path": "$BASE_PATH/.*"
    }
  },
  "prompts": [
    {
      "prompt-filter": {
        "constraints": {
          "path": ".*/example.txt",
          "permissions": [ "write" ],
          "available-permissions": [ "read", "write", "execute" ]
        }
      },
      "reply": {
        "action": "allow",
        "lifespan": "timespan",
        "duration": "1h",
        "constraints": {
          "path-pattern": "$BASE_PATH/example.txt",
          "permissions": [ "read", "write" ]
        }
      }
    },
    {
      "prompt-filter": {
        "constraints": {
          "path": ".*/example.txt",
          "permissions": [ "read" ],
          "available-permissions": [ "read", "write", "execute" ]
        }
      },
      "reply": null
    }
    ...
  ]
}
```

## Variables

Bash style `$VAR_NAME` and `${VAR_NAME}` variables are supported within prompt sequence JSON
files, being replaced using the `--var "VAR_NAME:value"` command line flag as shown in the
example above. This is handled as a simple string replacement before attempting to parse the
file, so long as the resulting string parses as valid JSON prompt sequence you are free to
make use of variable substitution as you see fit.

In the event that a scripted client run fails, it will output the fully resolved script to
standard out as part of its exit behaviour so you are able to inspect what the final run
looked like.

## Fields

### Version

The only supported version at this time is `1`. This field is required.

### Prompt Filter

The top-level `prompt-filter` field is used to provide a filter that will be used
to determine which prompts the client will attempt to match against as part of the
provided `prompts` sequence. It is not required that you specify a top level filter,
but if you do then all prompts not matching it will be ignored by the scripted client.

> This is particularly useful for factoring out common elements such the name of the
> snap being matched against and based paths for home prompts etc.

See the `Prompt filter fields` section below for specific details on each of the
supported fields for a filter.

### Prompt cases

A sequence of prompt cases: a prompt filter allowing for structural matching
against the next prompt in the sequence along with a template for build the
reply to that prompt provided the filter matches. If the filter does not match
at any given point within the sequence, the client will exit with an error. If
all prompts in the sequence match then the client will exit with a `0` exit
code.

### Prompt filter fields

Fields for `prompt filters` are optional and if provided must match the prompt
seen at that point in the sequence.

#### Snap

The exact name of the snap that the prompt was generated for.

#### Interface

The snap interface that the prompt is for. Currently only `home` is supported.

#### Constraints

Prompt constraints are tied to the interface that the prompt applies to. For `home`
prompts the following fields are available:

- `path`: a regular expression that must match the path seen in the prompt
- `permissions`: the ordered list of permissions seen in the prompt
- `available-permissions`: the ordered list of available permissions seen in the prompt

### Reply templates

If you wish the client to send a reply for a particular prompt then you should provide
a reply template under the `reply` field of prompt case. This is the expected default
behaviour of the client. In order to expect that a certain prompt be observed as part
of the sequence but _not_ send a reply you must explicitly provide `"reply": null`
rather than simply omitting the key.

When providing a reply template, the only required fields are the `action` (allow or deny)
and `lifespan` (single, session, forever or timespan). If `lifespan` is set to
timespan then the optional `duration` field must also be provided.

As with prompt filters, there is an interface specific set of constraints that may be
overwritten if needed. For the `home` interface these are:

- `path-pattern`: the path pattern to apply
- `permissions`: the permissions to request (must be a subset of the available permissions)
