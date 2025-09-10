#!/usr/bin/env sh

set -eu

device="$1"

if v4l2-ctl --device=$device --info >/dev/null; then
  echo "Allow access to camera"
else
  echo "Deny access to camera"
fi