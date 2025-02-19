# Architecture of the prompting client

The `prompting-client` snap is the client side of the Snapd [permissions prompting][0]
feature originally introduced in Ubuntu 24.10, providing the user-daemon itself
along with several command line tools for testing and debugging the behaviour
of the permissions prompting feature as a whole. This document is split into two
main sections covering the user facing functionality provided by the snap, and the
internal architecture of the daemon. If you are interested in the packaging of the
client you are encouraged to read through the `/snap/snapcraft.yaml` file in this
repository. For more details on using the scripted client please see [here][1].


## Functionality offered by the prompting-client snap
### The prompting-client daemon

The client itself runs as a systemd user service which is started by Snapd when the
`apparmor-prompting` feature is enabled and shuts down automatically when it detects
that the feature has been disabled. While prompting is enabled Snapd will emit
`interfaces-requests-prompt` notices from the [notices API][2] whenever a new prompt
is created or actioned. The daemon uses HTTP long polling to wait for and process
these notices by pulling the prompt and associated snap details from Snapd's REST
API and using the data to render the user interface.

For more details on the internal architecture of the daemon see the
[Design of the daemon][3] section below.


### The scripted client

`prompting-client.scripted` is a command line utility provided primarily for use in Snapd
[integration tests][4] as a programmatic client that can be driven by a config file
without the need for a graphical user interface. The configuration file describes
an expected sequence of prompts along with the replies that should be submitted in
response.

If the provided prompt sequence completes cleanly the client will print "success" on standard
out. If there are any errors then the first error will be printed as "error: $errorMessage" on
standard out and the client will exit with a non-zero exit code.

For more details on the structure of the config file please see [here][1].


### Viewing prompts on the system

`prompting-client.echo` is a simple command line utility that will print out the details
of each prompt notice that comes through on the system it is running on. If the optional
`--record <filepath>` flag is passed then the details of the prompts will be written to
a file when the program is exited using Ctrl-C. This client will never submit a
response to any of the prompts that it sees and is safe to run alongside the
daemon without interfering with its operation.


### Setting a logging level at runtime

`prompting-client.logging-level` is a helper command for setting the logging filter
used by the daemon while it is running. Doing this involves having to send a GRPC message
to the daemon which involves more plumbing than we'd ideally like but it allows us to
update the filter without having to restart the daemon.

Simple usage of this command involves specifying a level based filter for what logs
are written to the system journal by the prompting-client daemon. The supported levels
are (in order of least to most verbose): error, warn, info, debug and trace, with the
default level being info.

The logging framework used by the prompting client supports a rich syntax for specifying
more targetted filters when needed. As and when you need to use this in anger it is best
to refer to the documentation found [here][5] along with the source code of the client
itself to see what log messages can be targetted.


## Design of the daemon

### High level architecture

The prompting client daemon runs as three top level tasks that coordinate via mpsc channels,
similar to the common Go idiom of having multiple goroutines coordinate via channels. The
core event loop of the client is a sequential handling of each active prompt in the order
that they were received from Snapd, which is supported by a poll loop that is responsible
for processing the prompt notices coming from Snapd and a simple GRPC server that provides
an interface for the Flutter UI to communicate with the daemon. This architecture is
motivated by the following design constraints:

  1. Snapd provides details about active prompts through a pull model (the client long
     polling for notices) rather than a push model. This means that the client has to
     keep track of the currently known outstanding prompts explicitly rather than naively
     iterating over the prompt notices as they are received, as future notices may mark
     existing prompts in the queue as resolved.
  2. In order to serve an API for the UI to request and submit data we need a top level
     task listening on a socket. That task can't also be responsible for polling the
     notices API and spawning the UI.

Moving Snapd to a push model would require it to establish and maintain a persistent
connection to the prompting client at all times or, alternatively, move the majority of
the current client logic into Snapd and instead have Snapd directly spawn and interact
with the UI. The desire for Snapd to be unopinionated about how prompts are actioned
(in theory, supporting multiple client implementations) makes both of these approaches
impractical. On the UI side we have Flutter as our preferred UI framework and it is not
possible to run a Flutter application without first creating a GUI window, so we are
unable to write the daemon and UI as a single application. There are a number of
different ways we could handle the communication between the UI and the daemon, but GRPC
is our default approach for new applications in Ubuntu Desktop and fits our needs for
this use case.

### The poll loop

The poll loop task is responsible for pulling prompt details and snap meta-data from
snapd but does not directly process the prompts themselves. It first checks for any
outstanding (unactioned) prompts on the system for the user the daemon is running under
and processes them before dropping into long-polling the Snapd notices API. Each time
notices are received from Snapd they are either signaling the presence of a new prompt
that needs to be handled, or letting us know that an existing prompt has now been actioned
and that any state we have relating to that prompt ID should be dropped. For new prompt IDs,
the corresponding prompts are fetched and combined with metadata about the snap that
triggered the prompt before being sent to the worker loop for processing. For actioned
prompt IDs we instead send the worker a message instructing it to clear any state it has
for the ID.

The data sent through to the worker task is an unprocessed deserialization of the JSON
response returned by Snapd. While it _would_ be possible to map the data into our
internal representation at this point, we keep the raw form so that the poll loop logic
can be trivially reused in both the scripted and echo clients as well. Whichever
consumer of the prompt stream is in use is then in control over how the prompts are
handled.

If the poll loop receives a forbidden response from Snapd while trying to establish the
long poll it will force the daemon to restart so that the initialisation checks are run
again, checking to see if the prompting feature is enabled. If these fail then the daemon
will exit with a non-zero exit code, instructing systemd to not restart the service. If
any other non-200 response is received while attempting to establish the long poll, the
client will retry a fixed number of times before forcing a restart in the same way.


### The worker loop

The main worker loop task provides sequential processing of prompts as they are received
from snapd via the poll loop. Each iteration of the loop attempts to read all pending
prompt updates from the poll loop channel in order to check for notices instructing the
client to drop prompts that are pending in the internal buffer. Once the queue has been
drained and at least one prompt is available for processing, the prompt is mapped into
the data required by the Flutter UI and made available to the GRPC server. The Flutter
UI is then spawned as a subprocess and the worker task waits for the UI to exit, at which
point there should be an ack from the GRPC server that the prompt has been successfully
handled and the next prompt can be processed. If there is no ack from the GRPC server
(or if the prompt actioned by the GRPC server is not the one we were expecting) we log
and track the details for debugging purposes before moving to the next prompt. In
practice we do not see this failure mode occurring but it we want to make sure we have
all of the information we can if we ever do find that the expected state we have after
the Flutter UI exits is not correct.


### The GRPC server

The GRPC server task is arguably the simplest part of the prompting-client architecture.
It serves a small GRPC API defined in [protos/apparmor-prompting.proto][6] that allows
the Flutter UI to query the data associated with the currently active prompt and submit
a reply to be passed on to Snapd in response to that active prompt. We make use of
[tonic][7] to generate and serve the Rust side of the API and outside of mapping between
the generated protobuf types and our internal representation for the daemon, the
functionality of the server is limited to providing handlers for the various API endpoints
defined in the proto file.

### The Flutter UI

The Flutter front end for the prompting client aims to be driven by the data provided
by the daemon wherever possible rather than holding onto its own business logic. This
enables us to keep all of the logic around determining what the user will see in response
to a given prompt in one part of the code base, making it significantly easier to reason
about and debug. For the most part the Flutter UI is a simple presentation of a Snapd
interface specific UI that is determined by the data received from the daemon.


## Processing prompt data from Snapd

For the most part, the logic in the main event loop described above is agnostic to which
Snapd interface each processed prompt is associated with. The Flutter code obviously cares
about each interface as it needs to display a different UI for each one, but within the
daemon itself we confine the per-interface specific logic to implementations of the
[SnapInterface][8] trait which is used to parse and process the various data transformations
required to handle each type of prompt. The documentation comments on the trait itself
cover the specifics of how the trait is used to add support for a new Snapd interface,
but the core idea is that once we have succesfully parsed a raw JSON prompt from Snapd
based on its stated interface, we then have a strongly typed pipeline of data transformations
that take us from generating the data required by the UI through to submitting the user's
response back to Snapd. If you are interested in how this all works you are encouraged to
read the source code and documentation on the trait itself along with the guide on
[adding support for a new interface][9].



  [0]: https://discourse.ubuntu.com/t/ubuntu-desktop-s-24-10-dev-cycle-part-5-introducing-permissions-prompting/47963
  [1]: running-the-scripted-client.md
  [2]: https://snapcraft.io/docs/snapd-rest-api#heading--notices
  [3]: #design-of-the-daemon
  [4]: https://github.com/canonical/snapd/tree/master/tests/main/apparmor-prompting-integration-tests
  [5]: https://docs.rs/tracing-subscriber/latest/tracing_subscriber/filter/struct.EnvFilter.html  
  [6]: ../protos/apparmor-prompting.proto  
  [7]: https://docs.rs/tonic/latest/tonic/
  [8]: ../prompting-client/src/snapd_client/interfaces/mod.rs
  [9]: adding-support-for-new-interfaces.md
