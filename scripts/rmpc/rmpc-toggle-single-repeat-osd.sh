#!/usr/bin/env bash

# Get current state
status_json=$(rmpc status)
repeat=$(echo "$status_json" | jq -r '.repeat')
single=$(echo "$status_json" | jq -r '.single')

# Decide what to do
if [[ "$repeat" == "false" && "$single" == "Off" ]]; then
    # Turn both on
    rmpc repeat on
    rmpc single on
    swayosd-client --custom-message "  󰑘  "
else
    # Turn both off
    rmpc repeat off
    rmpc single off
    swayosd-client --custom-message "  󰒞  "
fi

