VM_NAME = aa-testing
SNAP_NAME = aa-prompting-test

.PHONY: snapd-prompting
snapd-prompting:
	lxc exec $(VM_NAME) -- snap refresh snapd --channel=latest/edge/prompting; \
	lxc exec $(VM_NAME) -- snap set system experimental.apparmor-prompting=true

.PHONY: snapd-stable
snapd-stable:
	lxc exec $(VM_NAME) -- snap refresh snapd --channel=latest/stable; \
	lxc exec $(VM_NAME) -- snap set system experimental.apparmor-prompting=false

# Sometimes we can get into a situation where snapd is stuck and stops sending notices
# for prompts. There is probably a lighter touch way of getting things working again
# but this does the trick.
.PHONY: bounce-snapd
bounce-snapd: snapd-stable snapd-prompting

.PHONY: create-vm
create-vm:
	if ! lxc info $(VM_NAME) 2>/dev/null ; then \
		lxc launch images:ubuntu/24.04/desktop $(VM_NAME) \
			--vm \
			-c limits.cpu=4 \
			-c limits.memory=4GiB; \
	elif ! lxc info $(VM_NAME) | grep "Status: RUNNING" ; then \
		lxc stop --force $(VM_NAME) 2>/dev/null; \
		lxc start $(VM_NAME); \
	fi
	while ! lxc exec $(VM_NAME) echo 2>/dev/null; do \
		echo "Waiting for $(VM_NAME) to be ready..."; \
		sleep 1; \
	done
	echo -e "\n:: Installing required packages..."
	lxc exec $(VM_NAME) -- apt install curl jq -y
	echo -e "\n:: Installing the latest/edge/prompting channel for snapd..."
	lxc exec $(VM_NAME) -- snap install snapd --channel=latest/edge/prompting
	echo -e "\n:: enabling prompting for snapd..."
	lxc exec $(VM_NAME) -- snap set system experimental.apparmor-prompting=true
	lxc file push prompt-loop.sh $(VM_NAME)/home/ubuntu/

.PHONY: attach-vm
attach-vm:
	lxc console --type=vga $(VM_NAME)

.PHONY: attach-vm-bash
attach-vm-bash:
	lxc exec --cwd=/home/ubuntu $(VM_NAME) -- su ubuntu

.PHONY: clean-test-snap
clean-test-snap:
	lxc exec $(VM_NAME) -- snap remove $(SNAP_NAME)

.PHONY: ensure-test-snap
ensure-test-snap:
	if ! lxc exec $(VM_NAME) -- snap info $(SNAP_NAME) > /dev/null ; then \
		snapcraft ; \
		lxc file push $(SNAP_NAME)_0.1_amd64.snap $(VM_NAME)/home/ubuntu/ ; \
		lxc exec $(VM_NAME) -- snap install --dangerous /home/ubuntu/$(SNAP_NAME)_0.1_amd64.snap ; \
	fi

.PHONY: update-test-snap
update-test-snap: clean-test-snap ensure-test-snap

.PHONY: clean-client-in-vm
clean-client-in-vm:
	lxc exec $(VM_NAME) -- rm -f /home/ubuntu/aa-prompt-client

.PHONY: ensure-client-in-vm
ensure-client-in-vm:
	if ! lxc exec $(VM_NAME) -- test -f /home/ubuntu/aa-prompt-client ; then \
		cd aa-prompt-client ; \
		cargo build ; \
		lxc file push target/debug/aa-prompt-client $(VM_NAME)/home/ubuntu/ ; \
	fi

.PHONY: update-client-in-vm
update-client-in-vm: clean-client-in-vm ensure-client-in-vm

.PHONY: prepare-vm
prepare-vm: create-vm ensure-test-snap ensure-client-in-vm

.PHONY: run-prompt-client
run-prompt-client: prepare-vm
	lxc exec --user=1000 $(VM_NAME) -- /home/ubuntu/aa-prompt-client

# update-client-in-vm:
# 	cd aa-prompt-client && cargo build
# 	lxc file push aa-prompt-client/target/debug/aa-prompt-client aa-testing/home/ubuntu/
# 	cd apparmor_prompt && flutter build linux
# 	lxc file push -r apparmor_prompt/build/linux/x64/release/bundle aa-testing/home/ubuntu/
# 	lxc exec aa-testing -- rm /var/lib/snapd/request-rules.json

.PHONY: integration-tests
integration-tests: create-vm ensure-test-snap
	cd aa-prompt-client && cargo test --no-run
	FNAME=$$(ls -ht aa-prompt-client/target/debug/deps/integration* | grep -Ev '\.d' | head -n1); \
	cp $$FNAME integration-tests; \
	lxc file push integration-tests $(VM_NAME)/home/ubuntu/; \
	rm integration-tests; \
	lxc exec $(VM_NAME) -- rm -rf /home/ubuntu/test; \
	lxc exec --user=1000 --env HOME=/home/ubuntu $(VM_NAME) /home/ubuntu/integration-tests;

.PHONY: clean
clean:
	lxc stop --force $(VM_NAME) 2>/dev/null || true
	lxc delete $(VM_NAME) 2>/dev/null || true
