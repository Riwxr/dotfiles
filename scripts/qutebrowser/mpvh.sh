#!/usr/bin/env bash

blank=$(printf "\n ")

notify-send "  MPV $blank" "hint-url loading..."

mpv --ytdl-format="best[height<=240]/best[height<=360]/best" --force-window yes $1
