VM_NAME = aa-testing
SNAP_NAME = prompting-client
SHORT_HASH = $(shell git rev-parse --short HEAD)
SNAP_FILE_NAME = $(SNAP_NAME)_0+git.$(SHORT_HASH)_amd64.snap
TEST_SNAP_NAME = aa-prompting-test
PROJECT_DIR = $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

.PHONY: install-local-tooling
install-local-tooling:
	@echo ":: Checking for lxd..."
	@if ! which lxd ; then \
		@echo ":: Installing lxd..." ; \
		snap install lxd ; \
		@echo ":: Adding user to the lxd group..." ; \
		getent group lxd | grep -qwF "$$USER" || usermod -aG lxd "$$USER" ; \
		@echo ":: Please log out and back in, or run 'newgrp lxd' for the change to take effect" ; \
	fi
	@echo ":: Checking for snapcraft..."
	@if ! which snapcraft ; then \
		@echo ":: Installing snapcraft..." ; \
		snap install snapcraft --classic ; \
	fi
	@echo ":: Checking for virt-viewer..."
	@if ! which virt-viewer ; then \
		@echo ":: Installing virt-viewer..." ; \
		apt install virt-viewer ; \
	fi

.PHONY: enable-prompting
enable-prompting:
	lxc exec $(VM_NAME) -- snap set system experimental.apparmor-prompting=true

.PHONY: disable-prompting
disable-prompting:
	lxc exec $(VM_NAME) -- snap set system experimental.apparmor-prompting=false

.PHONY: clean-request-rules
clean-request-rules:
	if lxc exec $(VM_NAME) -- test -d /var/lib/snapd/interfaces-requests ; then \
		lxc exec $(VM_NAME) -- rm -rf /var/lib/snapd/interfaces-requests ; \
	fi

# Sometimes we can get into a situation where snapd is stuck and stops sending notices
# for prompts. There is probably a lighter touch way of getting things working again
# but this does the trick.
.PHONY: bounce-snapd
bounce-snapd: disable-prompting clean-request-rules enable-prompting

.PHONY: create-or-start-vm
create-or-start-vm:
	@if ! lxc info $(VM_NAME) 2>/dev/null ; then \
		echo ":: Creating VM ($(VM_NAME))..."; \
		lxc launch images:ubuntu/24.04/desktop $(VM_NAME) \
			--vm \
			-c limits.cpu=4 \
			-c limits.memory=4GiB; \
	elif ! lxc info $(VM_NAME) | grep "Status: RUNNING" ; then \
		echo ":: Starting VM ($(VM_NAME))..."; \
		lxc stop --force $(VM_NAME) 2>/dev/null; \
		lxc start $(VM_NAME); \
	fi
	@while ! lxc exec $(VM_NAME) echo 2>/dev/null; do \
		echo ":: Waiting for VM ($(VM_NAME)) to be ready..."; \
		sleep 1; \
	done
	@sleep 5
	@echo ":: VM ($(VM_NAME)) now ready"
	@echo ":: Installing snapd..."
	@lxc exec $(VM_NAME) -- snap install snapd --channel=latest/edge
	@echo ":: Installing the app center..."
	@lxc exec $(VM_NAME) -- snap install snap-store --channel=latest/stable/ubuntu-24.04

.PHONY: attach-vm
attach-vm:
	lxc console --type=vga $(VM_NAME)

.PHONY: attach-vm-bash
attach-vm-bash:
	lxc exec --cwd=/home/ubuntu $(VM_NAME) -- su ubuntu

.PHONY: clean-client-in-vm
clean-client-in-vm:
	lxc exec $(VM_NAME) -- snap remove $(SNAP_NAME)

.PHONY: ensure-client-in-vm
ensure-client-in-vm:
	@echo ":: Checking for $(SNAP_NAME) in $(VM_NAME)..."
	@if ! lxc exec $(VM_NAME) -- snap list | grep $(SNAP_NAME) > /dev/null ; then \
		echo ":: Building $(SNAP_NAME) via snapcraft..." ; \
		rm -rf flutter_packages/prompting_client_ui/build ; \
		OLD=$(wildcard $(SNAP_NAME)_*) ; \
		[ -n "$$OLD" ] && rm $$OLD ; \
		snapcraft pack ; \
		FILE_NAME=$$(ls | grep -E '$(SNAP_NAME)_' | head -n1) ; \
		echo ":: Installing $(SNAP_NAME) in $(VM_NAME)..." ; \
		[ -n "$$OLD" ] && lxc exec $(VM_NAME) -- rm /home/ubuntu/$$OLD ; \
		lxc file push $$FILE_NAME $(VM_NAME)/home/ubuntu/ ; \
		lxc exec $(VM_NAME) -- snap set system experimental.user-daemons=true ; \
		lxc exec $(VM_NAME) -- snap install --dangerous /home/ubuntu/$$FILE_NAME ; \
		lxc exec $(VM_NAME) -- snap connect $(SNAP_NAME):snap-interfaces-requests-control ; \
		lxc exec $(VM_NAME) -- snap connect $(SNAP_NAME):camera ; \
		lxc exec $(VM_NAME) -- snap connect $(SNAP_NAME):audio-record ; \
	fi

.PHONY: update-client-in-vm
update-client-in-vm: clean-client-in-vm ensure-client-in-vm disable-prompting enable-prompting

.PHONY: clean-test-snap
clean-test-snap:
	lxc exec $(VM_NAME) -- snap remove $(TEST_SNAP_NAME)

.PHONY: ensure-test-snap
ensure-test-snap:
	@echo ":: Checking for $(TEST_SNAP_NAME) in $(VM_NAME)..."
	@if ! lxc exec $(VM_NAME) -- snap list | grep $(TEST_SNAP_NAME) > /dev/null ; then \
		echo ":: Building $(TEST_SNAP_NAME) via snapcraft..." ; \
		cd testing-snap ; \
		snapcraft pack ; \
		echo ":: Installing $(TEST_SNAP_NAME) in $(VM_NAME)..." ; \
		lxc file push $(TEST_SNAP_NAME)_0.1_amd64.snap $(VM_NAME)/home/ubuntu/ ; \
		lxc exec $(VM_NAME) -- snap install --dangerous /home/ubuntu/$(TEST_SNAP_NAME)_0.1_amd64.snap ; \
		echo ":: Connecting camera interface..." ; \
		lxc exec $(VM_NAME) -- snap connect $(TEST_SNAP_NAME):camera ; \
		lxc exec $(VM_NAME) -- snap connect $(TEST_SNAP_NAME):audio-record ; \
		lxc exec $(VM_NAME) -- apt install -y linux-modules-extra-$$(lxc exec $(VM_NAME) -- uname -r) v4l-utils ; \
		lxc exec $(VM_NAME) -- modprobe v4l2loopback ; \
		lxc exec $(VM_NAME) -- modprobe snd-aloop ; \
	fi

.PHONY: update-test-snap
update-test-snap: clean-test-snap ensure-test-snap

# There must be a snap with the snap-interfaces-requests-control interface
# connected and a "handler-service" attribute mapping to one of its app names,
# so we must ensure that the client is present before we try to enable
# prompting.
.PHONY: prepare-vm
prepare-vm: create-or-start-vm ensure-test-snap ensure-client-in-vm bounce-snapd

.PHONY: integration-tests
integration-tests:
	@echo ":: Checking cargo is available..."
	@if ! which cargo; then \
		echo ":: A local rust toolchain is required to run this target"; \
		exit 1; \
	fi
	@echo ":: Remember to run 'make prepare-vm' before running the integration tests"
	cd prompting-client && cargo test --no-run
	FNAME=$$(ls -ht prompting-client/target/debug/deps/integration* | grep -Ev '\.d' | head -n1); \
	cp $$FNAME integration-tests; \
	lxc file push integration-tests $(VM_NAME)/home/ubuntu/; \
	rm integration-tests; \
	lxc exec $(VM_NAME) -- rm -rf /home/ubuntu/test; \
	lxc exec --user=1000 --env HOME=/home/ubuntu $(VM_NAME) /home/ubuntu/integration-tests $(CASES);

.PHONY: clean
clean:
	lxc stop --force $(VM_NAME) 2>/dev/null || true
	lxc delete $(VM_NAME) 2>/dev/null || true

# Targets for local use rather than against the VM

.PHONY: local-enable-prompting
local-enable-prompting:
	snap set system experimental.apparmor-prompting=true

.PHONY: local-disable-prompting
local-disable-prompting:
	snap set system experimental.apparmor-prompting=false

.PHONY: local-clean-request-rules
local-clean-request-rules:
	if test -d /var/lib/snapd/interfaces-requests ; then \
		rm -rf /var/lib/snapd/interfaces-requests ; \
	fi

.PHONY: local-bounce-snapd
local-bounce-snapd: local-disable-prompting local-clean-request-rules local-enable-prompting

.PHONY: local-install-client
local-install-client:
	echo ":: Building $(SNAP_NAME) via snapcraft..." ; \
	rm -rf flutter_packages/prompting_client_ui/build ; \
	OLD=$(wildcard $(SNAP_NAME)_*) ; \
	rm $$OLD ; \
	snapcraft pack ; \
	FILE_NAME=$$(ls | grep -E '$(SNAP_NAME)_' | head -n1) ; \
	echo ":: Installing $(SNAP_NAME)..." ; \
	snap install --dangerous $$FILE_NAME ; \
	snap connect $(SNAP_NAME):snap-interfaces-requests-control ; \
	snap connect $(SNAP_NAME):camera ;

# ==== MOCK SERVER ====

LOG_LEVEL = debug
CLIENT_SOCKET = $(shell mktemp -u)
PIPE ?= $(shell mktemp -u -t pipe.XXXXXX)
SOCKET ?= $(shell mktemp -u -t mock.sock.XXXXXX)

# Use 'sort -r' sorting in reverse order, ensuring that release artifacts appear before debug or other variants.
FLUTTER_UI ?= $(shell find $(PROJECT_DIR) -type f -executable -path '*/bundle/prompting_client_ui' | sort -r | head -n1)

.PHONY: start-mock-server
start-mock-server:
	cd mock-server; PIPE_PATH=$(PIPE) SOCKET_PATH=$(SOCKET) RUST_LOG=$(LOG_LEVEL) cargo run --release; cd .. ;

.PHONY: dev-mock-server
dev-mock-server:
	cd mock-server; PIPE_PATH=$(PIPE) SOCKET_PATH=$(SOCKET) RUST_LOG=$(LOG_LEVEL) cargo watch -cqx run ; cd .. ;

.PHONY: dev-prompting-client
dev-prompting-client:
	cd prompting-client ; \
	RUST_LOG=$(LOG_LEVEL) \
	SNAP_REAL_HOME=$(HOME) \
	SNAPD_SOCKET_OVERRIDE=$(SOCKET) \
	FLUTTER_UI_OVERRIDE=$(FLUTTER_UI) \
	PROMPTING_CLIENT_SOCKET=$(CLIENT_SOCKET) \
	cargo watch -cqx "run --bin prompting-client-daemon --features dry-run" ; \
	cd .. ;
