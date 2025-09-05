#!/usr/bin/env sh

if v4l2-ctl --list-devices > /dev/null; then
  echo "Allow access to camera"
else
  echo "Deny access to camera"
fi