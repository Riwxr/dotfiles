#!/usr/bin/env bash


#--------------------------------------------------

COOLDOWN=3
STAMP_FILE="/tmp/my_script_last_run"

if [[ -f "$STAMP_FILE" ]]; then
    last=$(stat -c %Y "$STAMP_FILE")
    now=$(date +%s)
    (( now - last < COOLDOWN )) && exit 0
fi


touch "$STAMP_FILE"
#--------------------------------------------------

signs=( "" "󰛄" "" "" "󰛄" "󰛄" "" )
dots=("." ".." "...")
blank=$(printf "\n ")


id=$(notify-send -p "Toss $blank" " Flipping..." -a "toss")
play ~/sound/coin-flip.wav &
pid=$!

while kill -0 "$pid" 2>/dev/null; do
	for b in ${dots[@]}; do
		for i in "${signs[@]}"; do
      			notify-send --replace-id=$id -a toss "Toss $blank" "$i Flipping$b"
      			sleep .1
    		done
	done
done


options="  Heads
  Tails"

output=$(printf "%s\n" "$options" | shuf -n 1)

play ~/sound/single-coin-toss.wav &
notify-send --replace-id=$id "Toss $blank" " $output" -a "toss"

#--------------------------------------------------


