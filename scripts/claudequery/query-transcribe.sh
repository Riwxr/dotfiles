#!/usr/bin/env bash
echo "trascribing..."
echo "query-transcribe"

blank=$(printf "\n ")

if [[ ! -s ~/scripts/claudequery/query.wav ]]; then
    notify-send "󰔮  Whisper $blank" "Recording missing or empty"
    exit 1
fi

whisper ~/scripts/claudequery/query.wav \
    --model turbo -f json --language en \
    --device cpu --fp16 False \
    --output_dir ~/scripts/claudequery

if [[ -s ~/scripts/claudequery/query.json ]]; then
    notify-send "󰔮  Whisper" "Transcribe completed succusfully"
else
    notify-send "󰔮  Whisper Error" "Model '$choice' failed."
    rm -f /tmp/query.json
    read -rp "Try Again?"
fi

Output=$(cat ~/scripts/claudequery/query.json | jq -r '.text | ltrim')

echo "$Output" >~/scripts/claudequery/input.txt
