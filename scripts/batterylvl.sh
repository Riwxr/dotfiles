#!/usr/bin/env bash

lvl=$(cat "/sys/class/power_supply/BAT0/capacity")

c1=${lvl:0:1}
c2=${lvl: -1}

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
battery_alert=("┳┓┏┓┏┳┓┏┳┓┏┓┳┓┓┏  ┓ ┏┓┓ ┏  ┏━┓ " "┣┫┣┫ ┃  ┃ ┣ ┣┫┗┫  ┃ ┃┃┃┃┃  ┃┗┛ " "┻┛┛┗ ┻  ┻ ┗┛┛┗┗┛  ┗┛┗┛┗┻┛  ┗━┛ ")
percent=("•┏" " ┃ " " ┛•")
declare -n d1="n$c1"
declare -n d2="n$c2"

echo " "
for i in 0 1 2; do
  echo "                                     ${battery_alert[$i]} ${d1[$i]} ${d2[$i]} ${percent[$i]}"
done
echo " "
