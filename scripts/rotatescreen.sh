#!/usr/bin/env bash

a="  Normal - 0"
b="  Vertial - 90"
c="  Flipped - 180"
d="  Vertial - 270"

x=$(echo -e "$a\n$b\n$c\n$d" | walker -d -n -H --height=160 -e -i)

case "$x" in
0) y=normal ;;
1) y=90 ;;
2) y=180 ;;
3) y=270 ;;
*) exit 0 ;;
esac

wlr-randr --output eDP-1 --transform $y
