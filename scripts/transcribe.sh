#!/usr/bin/env bash

cleanup() {
  rm -f /tmp/transcribe.txt
}
trap cleanup EXIT


if ! gum confirm "Start Recording?"; then
	hyprctl dispatch closewindow class:transcribe
	exit 0
fi

copyorwrite=$(gum choose Copy Write)

rm -f /tmp/transcribe.wav

rec /tmp/transcribe.wav &
rec_pid=$!

read -r

kill -TERM "$rec_pid"
wait "$rec_pid"

yes "" | head -n 5

play /tmp/transcribe.wav &
play_pid=$!

while kill -0 "$play_pid" 2>/dev/null; do
    read -r -t 0.1 && break
done

kill -TERM "$play_pid" 2>/dev/null
wait "$play_pid" 2>/dev/null

if [[ ! -s /tmp/transcribe.wav ]]; then
  notify-send "Whisper" "Recording missing or empty"
  exit 1
fi

DEFAULT="Turbo"

while true; do

	choice=$(gum choose Turbo Small Base Tiny --timeout=5s)
	status=$?

	case "$status" in
	  0)
	    # user selected something → use $choice
	    ;;
	  124)
	    # timeout → force default
	    choice="Turbo"
	    ;;
	  1)
	    # ESC → close window + exit
	    hyprctl dispatch closewindow class:transcribe
	    exit 0
	    ;;
	  *)
	    hyprctl dispatch closewindow class:transcribe
	    exit 1
	    ;;
	esac


	case "$choice" in
	  Turbo) model="turbo" ;;
	  Small) model="small.en" ;;
	  Base)  model="base.en" ;;
	  Tiny)  model="tiny.en" ;;
	  *) continue ;;
	esac


	echo "Using $choice"
	whisper /tmp/transcribe.wav --model "$model" -f json --language en --device cpu --fp16 False --output_dir /tmp/

	whisper_status=$?
	
	if [[ $whisper_status -eq 0 && -s /tmp/transcribe.json ]]; then
		break
	else
		notify-send "Whisper Error" "Model '$choice' failed."
		rm -f /tmp/transcribe.txt
		read -rp "Try Again?"
	fi
done

Output=$(cat /tmp/transcribe.json | jq -r '.text | ltrim')

if [[ $copyorwrite == Copy ]]; then
	wl-copy "$Output"
elif [[ $copyorwrite == Write ]]; then
	wtype "$Output"
fi

swayosd-client --custom-message "Whisper - Transcribe Copied"

hyprctl dispatch closewindow class:transcribe

