#!/usr/bin/env bash

# Check if rmpc client is alive
if hyprctl clients | grep -q '"class": "rmpc"'; then
    # Exists → toggle
    hyprscratch rmpc toggle
else
    # Doesn't exist → launch
    hyprscratch rmpc ~/rmpc/launch_rmpc.sh
fi
