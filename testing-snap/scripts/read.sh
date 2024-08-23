#!/usr/bin/env sh

prefix="$1"

#cat "${SNAP_REAL_HOME}/test/${prefix}/test.txt"

log="${SNAP_REAL_HOME}/snap/aa-prompting-test/common/log.txt"

# Prepare a directory which can be written to by the snap without a prompt
mkdir -p "${SNAP_REAL_HOME}/snap/aa-prompting-test/common/test/${prefix}" 2>> "${log}"

# The `tee` is what should produce the stdout for this test
cat "${SNAP_REAL_HOME}/test/${prefix}/test.txt" | tee "${SNAP_REAL_HOME}/snap/aa-prompting-test/common/test/${prefix}/test.txt"

echo "The following was written to ${SNAP_REAL_HOME}/snap/aa-prompting-test/common/test/${prefix}/test.txt:" >> "${log}"

cat "${SNAP_REAL_HOME}/snap/aa-prompting-test/common/test/${prefix}/test.txt" >> "${log}"

echo "The following are all running processes containing 'cat':" >> "${log}"

echo "ps -aux | grep 'cat'" >> "${log}"

ps -aux | grep 'cat' >> "${log}"

