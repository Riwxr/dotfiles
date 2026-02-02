#!/usr/bin/env bash


PID=$(hyprctl -j activewindow | jq -r '.pid')

pw-dump |jq '.[] | select(.info.props["application.process.id"] == $PID)' | jq '.info.props["object.id"]'
