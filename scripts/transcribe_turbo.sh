#!/usr/bin/env bash

cleanup() {
  rm -f /tmp/transcribe_turbo.txt
}

signs=( "" "󰛄" "" "" "󰛄" "󰛄" "" )
dots=("." ".." "...")
blank=$(printf "\n ")


trap cleanup EXIT

rm -f /tmp/transcribe_turbo.wav

rec /tmp/transcribe_turbo.wav &
rec_pid=$!

read -r

kill -TERM "$rec_pid"
wait "$rec_pid"

if [[ ! -s /tmp/transcribe_turbo.wav ]]; then
  notify-send "󰔮  Whisper $blank" "Recording missing or empty"
  exit 1
  hyprctl dispatch closewindow class:transcribe
fi

hyprctl dispatch movetoworkspacesilent 1
x=6
x=$(notify-send -p "󰔮  Whisper $blank" "Starting...")


whisper /tmp/transcribe_turbo.wav --model turbo -f json --language en --device cpu --fp16 False --output_dir /tmp/ &
pid=$!
	
while kill -0 "$pid" 2>/dev/null; do
	for b in ${dots[@]}; do
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

hyprctl dispatch closewindow class:transcribe

