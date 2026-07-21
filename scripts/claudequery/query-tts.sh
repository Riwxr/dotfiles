#!/usr/bin/env bash
# Kill previous TTS if running
lastPID=$(cat ~/.local/querytts.log 2>/dev/null)
[[ -n "$lastPID" ]] && kill "$lastPID" 2>/dev/null

path=$1
blank=$(printf "\n ")
text=$(cat "$path")
[[ -z "$text" ]] && notify-send "󰔋  TTS $blank" "No Input." -u low && exit 0

id=$(notify-send -p "󰔊  TTS $blank" "TTS Starting" -t 6000 -u low)

cleanup() {
    notify-send "󰔋  TTS $blank" "TTS killed" --replace-id="$id"
    rm -f ~/.local/querytts.log
    exit 130
}
trap cleanup SIGINT SIGTERM

status=$(playerctl -a status 2>/dev/null)

# Run in foreground — stays in process group, killpg reaches it
edge-tts --voice "en-US-AvaNeural" --text "$text" | mpv --config-dir="~/.config/mpv-tts" -

EXIT=$?
rm -f ~/.local/querytts.log

[[ "$status" == "Playing" ]] && playerctl -a play

if [[ $EXIT -eq 0 ]]; then
    notify-send --replace-id="$id" "󰔊  TTS $blank" "TTS Complete." -a toss -u low
else
    notify-send "󰔋  TTS $blank" "TTS Failed" --replace-id="$id" -u low
    exit 130
fi
