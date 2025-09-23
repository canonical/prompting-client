## Getting set up for local development

### Running in a lxd VM (Recommended)

So long as you have `lxd` installed you will be able to quickly spin up and
bootstrap a VM for local testing against the `latest/edge` channel
of snapd.

> If you have your own preferred workflow for local development and testing
> this is not a requirement, but it does help standardise how we test changes
> on both the client and snapd sides.

The first time you are setting up your test VM, running the following from
your host should be sufficient to get you a local testing environment.

```bash
sudo make install-local-tooling
make prepare-vm
```

This will install the required local tooling for provisioning the VM and
building both the prompting client snap and a simple test snap which is used as
part of the integration test suite (see below). If you did not already have
`lxd` installed, you will need to log out and back in for your user to be added
to be able to interact with lxd. Alternatively you can run `newgrp lxd` as
described in [the lxd installation docs](https://documentation.ubuntu.com/lxd/en/latest/installing/).

Once the VM is up and running you then need to run `make attach-vm` to open a
VGA console and close gnome-initial-setup. The client runs as a user daemon so
you it should already be running in the VM by the time you open the VGA console.

### Running locally

If you are already inside of an Ubuntu VM or want to try running apparmor
prompting on your host, you can use the `local-*` Makefile targets to build and
install the client locally:

> **NOTE**: This currently requires using the `edge` channel of snapd.

```bash
snap refresh snapd --channel=edge
make local-install-client
make local-enable-prompting
```

To uninstall the client simply remove it as you would any other snap:

```bash
snap remove prompting-client
make local-disable-prompting
```

## Running the integration tests

If you have a local Rust toolchain installed you will be able to build and run
the integration test suite like so (To get set up with Rust locally on Ubuntu,
see the Bootstrapping a new Rust installation section of [this blog post](https://ubuntu.com/blog/why-and-how-to-use-rust-on-ubuntu)):

```bash
make integration-tests
```

> **Note**: this shares the same `aa-testing` VM as the other `make` directives.

This test suite is not intended for full coverage of the API interactions
between the client and snapd, but it should be sufficient to check and validate
the behaviour of the client against the most recent `latest/edge`
channel of snapd.
