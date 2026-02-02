#!/usr/bin/env bash

hours=$(date +"%H")
mins=$(date +"%M")

h1=${hours:0:1}
h2=${hours: -1}
m1=${mins:0:1}
m2=${mins: -1}

n1=(" ┓" " ┃" " ┻")
n2=("┏┓" "┏┛" "┗┛")
n3=("┏┓" " ┫" "┗┛")
n4=("╻╻" "┗╋" " ┻")
n5=("┏┓" "┗┓" "┗┛")
n6=("┏┓" "┣┓" "┗┛")
n7=("━┓" " ┃" " ╹")
n8=("┏┓" "┣┫" "┗┛")
n9=("┏┓" "┗┫" "┗┛")
n0=("┏┓" "┃┃" "┗┛")
nd=("  " " 𜴶" "  ")

declare -n d1="n$h1"
declare -n d2="n$h2"
declare -n d3="n$m1"
declare -n d4="n$m2"

for i in 0 1 2; do
  echo "${d1[$i]} ${d2[$i]} ${nd[$i]} ${d3[$i]} ${d4[$i]}"
done
