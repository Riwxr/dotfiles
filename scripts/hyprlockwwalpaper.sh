#!/usr/bin/env bash

path=$(awww query -a | awk '{print $NF}')
vari='$wal'
text="$vari = $path"

echo "$text" >~/.cache/wallpaper.conf
