#! /usr/bin/env bash
hours=$(date +"%-I")
mins=$(date +"%-M")
min_in_fraction=$(((mins + 2) / 5))
[[ $hours -eq 12 ]] && hours=0

build_ticks() {
    local count=$1
    local groups=$((count / 3))
    local rem=$((count % 3))
    local out=""
    for ((g = 0; g < groups; g++)); do
        out+="┃"
    done
    for ((r = 0; r < rem; r++)); do
        out+="│"
    done
    echo "$out"
}

groups_hours=$((hours / 3))
groups_mins=$((min_in_fraction / 3))

surplus_hours=$(((12 - hours) + 2 * groups_hours))
surplus_mins=$(((12 - min_in_fraction) + 2 * groups_mins))

dot_hours=$(build_ticks "$hours")
dot_mins=$(build_ticks "$min_in_fraction")

grave_hours=$(printf '%.0s`' $(seq 1 $surplus_hours))
grave_mins=$(printf '%.0s`' $(seq 1 $surplus_mins))
echo "$grave_hours$dot_hours  ^  $dot_mins$grave_mins"
