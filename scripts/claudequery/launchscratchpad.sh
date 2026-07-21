#! /usr/bin/env bash

mmsg -d toggle_named_scratchpad,chromium,none,~/scripts/claudequery/launch.sh

# Watch for Chromium focus steal, toggle it back
(
    mmsg -wc | while read -r line; do
        if [[ "$line" == *"appid chromium"* ]]; then
            ~/scripts/claudequery/togglechromium.sh && ydotool click 0xC0
            break
        fi
    done
) &

exit 0
