#!/usr/bin/env bash

# Check if rmpc client is alive
if pgrep -fa "kdeconnect-app" > /dev/null; then
    # Exists → toggle
    hyprscratch "KDE Connect" toggle
else
    # Doesn't exist → launch
    hyprscratch "KDE Connect" kdeconnect-app
fi

