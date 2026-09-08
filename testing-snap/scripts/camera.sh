#!/usr/bin/env sh

set -eu

device="$1"

if dd if="$device" of=/dev/null count=0 2>/dev/null; then
  echo "Allow access to camera"
else
  echo "Deny access to camera"
  echo "Failed to open $device: Permission denied" >&2
fi
