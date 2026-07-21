#!/usr/bin/env bash

if [[ ! $1 == "--no-rec" ]]; then
    cleanup() {
        rm -f /tmp/transcribe_turbo.txt
        rm -f ~/scripts/claudequery/output.txt
    }

    trap cleanup EXIT

    rm -f /tmp/transcribe_turbo.wav

    rec /tmp/transcribe_turbo.wav &
    rec_pid=$!

    read -r

    kill -TERM "$rec_pid"
    wait "$rec_pid"
fi
echo recdone

tag=$(mmsg -g -t | awk '/^[^ ]+ tag [0-9]+ 1/ {print $3}')
echo "$tag" >~/.cache/lasttagquery.log
setsid -f foot --app-id chromium bash -c ~/scripts/claudequery/query.sh >/dev/null 2>&1 </dev/null
