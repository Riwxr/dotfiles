#!/usr/bin/env bash

pkill -f "ungoogled.chromium" 2>/dev/null
pkill -f "remote-debugging-port" 2>/dev/null
sleep 1

python ~/scripts/claudequery/claudequery.py -i ~/scripts/claudequery/input.txt -o ~/scripts/claudequery/output.txt &&
    pkill -f "ungoogled.chromium" 2>/dev/null
pkill -f "remote-debugging-port" 2>/dev/null

sed -i '1d' ~/scripts/claudequery/output.txt
