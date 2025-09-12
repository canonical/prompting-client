#!/usr/bin/env sh

set -eu

device="$1"

if arecord -D $device -f S16_LE -d 1 /dev/null > /dev/null; then
  echo "Allow access to microphone"
else
  echo "Deny access to microphone"
fi
