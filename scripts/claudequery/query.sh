#!/usr/bin/env bash

~/scripts/claudequery/query-transcribe.sh &&
    ~/scripts/claudequery/query-fetch.sh &&
    ~/scripts/claudequery/query-tts.sh ~/scripts/claudequery/output.txt && notify-send "ready for next query"
