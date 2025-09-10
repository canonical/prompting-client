# Contributing to the Prompting Client

A big welcome and thank you for considering contributing to the Prompting
Client and Ubuntu! It’s people like you that make it a reality for users in our
community.

Reading and following these guidelines will help us make the contribution
process easy and effective for everyone involved. It also communicates that you
agree to respect the time of the developers managing and developing this
project. In return, we will reciprocate that respect by addressing your issue,
assessing changes, and helping you finalize your pull requests.

These are mostly guidelines, not rules. Use your best judgment, and feel free
to propose changes to this document in a pull request.

## Quicklinks

* [Code of Conduct](#code-of-conduct)
* [Getting Started](#getting-started)
* [Issues](#issues)
* [Pull Requests](#pull-requests)
* [Contributing to the code](#contributing-to-the-code)
* [Contributor License Agreement](#contributor-license-agreement)
* [Getting Help](#getting-help)

## Code of Conduct

We take our community seriously and hold ourselves and other contributors to
high standards of communication. By participating and contributing to this
project, you agree to uphold our [Code of Conduct](https://ubuntu.com/community/code-of-conduct).

## Getting Started

Contributions are made to this project via Issues and Pull Requests (PRs). A
few general guidelines that cover both:

* For reporting security issues, please see [SECURITY.md](SECURITY.md).
* Search for existing Issues and PRs on this repository before creating your own.
* We work hard to makes sure issues are handled in a timely manner but,
  depending on the impact, it could take a while to investigate the root cause.
  A friendly ping in the comment thread to the submitter or a contributor can
  help draw attention if your issue is blocking.
* If you've never contributed before, see [this Ubuntu discourse post](https://discourse.ubuntu.com/t/contribute/26)
  for resources and tips on how to get started.

### Issues

Issues should be used to report problems with the software, request a new
feature, or to discuss potential changes before a PR is created. When you
create a new Issue, a template will be loaded that will guide you through
collecting and providing the information we need to investigate.

If you find an Issue that addresses the problem you're having, please add your
own reproduction information to the existing issue rather than creating a new
one. Adding a [reaction](https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/)
can also help be indicating to our maintainers that a particular problem is
affecting more than just the reporter.

### Pull Requests

PRs to our project are always welcome and can be a quick way to get your fix or
improvement slated for the next release. In general, PRs should:

* Only fix/add the functionality in question **OR** address wide-spread whitespace/style issues, not both.
* Add unit or integration tests for fixed or changed functionality.
* Address a single concern in the least number of changed lines as possible.
* Include documentation in the repo or on our [docs site](https://github.com/canonical/prompting-client/wiki).
* Be accompanied by a complete Pull Request template (loaded automatically when a PR is created).

For changes that address core functionality or would require breaking changes
(e.g. a major release), it's best to open an Issue to discuss your proposal
first. This is not required but can save time creating and reviewing changes.

In general, we follow the ["fork-and-pull" Git workflow](https://github.com/susam/gitpr)

1. Fork the repository to your own Github account
1. Clone the project to your machine
1. Create a branch locally with a succinct but descriptive name
1. Commit changes to the branch
1. Following any formatting and testing guidelines specific to this repo
1. Push changes to your fork
1. Open a PR in our repository and follow the PR template so that we can efficiently review the changes.

> PRs will trigger unit and integration tests with and without race detection,
> linting and formatting validations, static and security checks, freshness of
> generated files verification. All the tests must pass before merging in main
> branch.

Once merged to the main branch, `po` files and any documentation change will be
automatically updated. Those are thus not necessary in the pull request itself
to minimize diff review.

## Contributing to the code

### Required dependencies

#### Rust

[Install rustup](https://www.rust-lang.org/tools/install) - the currently
used version is specified in `.tool-versions`.

Install the [protobuf-compiler](https://packages.ubuntu.com/noble/protobuf-compiler)
and its dependencies.
```bash
$ sudo apt update
$ sudo apt install -y git gcc libssl-dev pkg-config protobuf-compiler
```

#### Flutter

[Install Flutter](https://flutter.dev/docs/get-started/install/linux) - the
currently used version is specified in `.fvmrc`. If you're using
[fvm](https://fvm.app) to manage your Flutter SDK, you can simply run `fvm
install` to install the required version.

Install the [Flutter Linux
prerequisites](https://docs.flutter.dev/get-started/install/linux#linux-prerequisites)

We provide a [Melos](https://docs.page/invertase/melos) configuration to make it
straightforward to execute common tasks.

Install fvm (you can also install it from the scripts directory in the
repository):
```bash
$ curl -fsSL https://fvm.app/install.sh | bash
```

Install Melos:
```bash
$ dart pub global activate melos
```

Bootstrap the monorepo:
```bash
$ melos bootstrap
```

`melos bootstrap` connects all the local packages/apps to each other with the
help of `pubspec_overrides.yaml` files, and it also runs `pub get` in all
packages/apps.

### Building and running the binaries

TODO

### About the testsuite

The project includes a comprehensive testsuite made of unit and integration
tests. All the tests must pass before the review is considered. If you have
troubles with the testsuite, feel free to mention it on your PR description.

#### Rust
```bash
$ cd prompting-client
$ cargo test --lib
```

#### Flutter
```bash
$ melos test
```

#### Flutter dry-run mode
It is possible to spawn a prompt using `dry-run` mode and a `.json` file without
hardcoded prompt details in it. This can be very useful for testing UI changes.

You can initiate `dry-run` mode from the `/flutter/apps/prompting_client_ui` 
using:
```bash
 fvm flutter run -a --dry-run
```

You can specify a specific `.json` file for testing using the `--test-prompt`
argument:
```bash
fvm flutter run -a --dry-run -a --test-prompt \
  -a test/test_prompts/test_camera_prompt_details.json
```

#### Integration tests
Running the integration tests locally requires a running Ubuntu VM:
```bash
$ make prepare-vm
$ make integration-tests
```

The test suite must pass before merging the PR to our main branch. Any new
feature, change or fix must be covered by corresponding tests.

### Code style

This project follow the Rust and Flutter code-styles. For more informative
information about the code style in use, please check:

* For Rust: <https://doc.rust-lang.org/1.0.0/style/README.html>
* For Flutter: <https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo>

## Contributor License Agreement

It is required to sign the [Contributor License Agreement](https://ubuntu.com/legal/contributors)
in order to contribute to this project.

An automated test is executed on PRs to check if it has been accepted.

This project is covered by [GPL-3](LICENSE).

## Getting Help

Join us in the [Ubuntu Community](https://discourse.ubuntu.com/c/desktop/8) and
post your question there with a descriptive tag.
