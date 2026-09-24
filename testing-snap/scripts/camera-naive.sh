#!/usr/bin/env sh

set -eu

device="$1"

if cat "$device" ; then
  echo "Allow access to $device"
else
  echo "Deny access to $device"
fi
