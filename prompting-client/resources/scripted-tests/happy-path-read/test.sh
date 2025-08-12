#!/usr/bin/env sh
# A simple allow once test of a read prompt.
# Running this test script requires that the accompanying prompt-sequence.json
# file be present in the output directory.

PREFIX="$1"
TEST_DIR="$HOME/test/$PREFIX"

prompting-client.scripted \
  --script="$TEST_DIR/prompt-sequence.json" \
  --var "BASE_PATH:$TEST_DIR" | tee "$TEST_DIR/outfile" &

# Ensure that the test client is already listening
sleep 0.2
TEST_OUTPUT="$(aa-prompting-test.read "$PREFIX")"

# Ensure that the test client has time to write its output
# For tests with a grace period this will need to be taken into account as well
sleep 0.2
CLIENT_OUTPUT="$(cat "$TEST_DIR/outfile")"

if [ "$CLIENT_OUTPUT" != "success" ]; then
  echo "test failed"
  echo "output='$CLIENT_OUTPUT'"
  exit 1
fi

if [ "$TEST_OUTPUT" != "testing testing 1 2 3" ]; then
  echo "test script failed"
  exit 1
fi
