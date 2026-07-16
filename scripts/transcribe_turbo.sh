#!/usr/bin/env bash

signs=("" "󰛄" "" "" "󰛄" "󰛄" "")
dots=("." ".." "...")
blank=$(printf "\n ")

if [[ $1 == "-i" ]]; then
    wav="$2"
else
    cleanup() {
        rm -f /tmp/transcribe_turbo.txt
    }

    trap cleanup EXIT
    rm -f /tmp/transcribe_turbo.wav
    reco --no-hold --once -o /tmp/transcribe_turbo.wav
    if [[ ! -s /tmp/transcribe_turbo.wav ]]; then
        notify-send "󰔮  Whisper $blank" "Recording missing or empty"
        exit 1
    fi
    wav="/tmp/transcribe_turbo.wav"
fi
if [[ $3 == "-o" ]]; then
    dir="$4"
else
    dir=/tmp/
fi
x=6
x=$(notify-send -p "󰔮  Whisper $blank" "Starting...")

whisper "$wav" --model turbo -f json --language en --device cpu --fp16 False --output_dir "$dir"
pid=$!

while kill -0 "$pid" 2>/dev/null; do
    for b in "${dots[@]}"; do
        for i in "${signs[@]}"; do
            notify-send --replace-id=$x -a toss "󰔮  Whisper $blank" "$i Transcribing$b"
            sleep .1
        done
    done
done

if [[ -s /tmp/transcribe_turbo.json ]]; then
    notify-send --replace-id=$x "󰔮  Whisper" "Transcribe completed succusfully"
else
    notify-send --replace-id=$x "󰔮  Whisper Error" "Model '$choice' failed."
    rm -f /tmp/transcribe_turbo.txt
    read -rp "Try Again?"
fi

Output=$(cat /tmp/transcribe_turbo.json | jq -r '.text | ltrim')

wl-copy "$Output"
