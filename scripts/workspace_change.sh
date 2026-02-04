#! /usr/bin/env bash

x=$(hyprctl activeworkspace | grep '^workspace ID' | cut -d' ' -f3)
mapfile -t ws_ids < <(
  hyprctl workspaces \
  | awk '/^workspace ID/ {print $3}' \
  | grep -E '^[0-9]+$' \
  | sort -n
)

smaller=0
larger=0
y=$(( x + 1 ))
z=$(( x - 1 ))

for v in "${ws_ids[@]}"; do

(( v < x )) && smaller=1
(( v > x )) && larger=1
done

if (( smaller == 0 && larger == 1 )); then
    if [[ $1 == "L" ]]; then
        if [[ $x == 2 ]]; then
		hyprctl dispatch workspace 1
		exit 0
	else
		exit 0
	fi
    elif [[ $1 == "L4" ]]; then
           hyprctl dispatch workspace $z
    fi
fi

if (( smaller == 1 && larger == 0 )); then
    if [[ $1 == "R" ]]; then
	exit 0
    elif [[ $1 == "R4" ]]; then
           hyprctl dispatch workspace $y
    fi
fi

if [[ $1 == "L" ]]; then
        if [[ $x == 2 ]]; then
		hyprctl dispatch workspace 1
		exit 0
	fi
	hyprctl dispatch workspace e-1 
elif [[ $1 == "R" ]]; then
	hyprctl dispatch workspace e+1
elif [[ $1 == "L4" ]]; then
        hyprctl dispatch workspace $z
elif [[ $1 == "R4" ]]; then
        hyprctl dispatch workspace $y
fi

