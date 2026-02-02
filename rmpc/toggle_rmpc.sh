#!/usr/bin/env bash

# Check if rmpc client is alive
if pgrep -fa "kitty --class rmpc" > /dev/null; then
    # Exists → toggle
    hyprscratch rmpc toggle
else
    # Doesn't exist → launch
    hyprscratch rmpc ~/rmpc/launch_rmpc.sh
fi

