#! /usr/bin/env bash

Url=$(cat ~/.cache/mpv-his.log | sort -r | walker -d --minheight 1 -H 2>/dev/null | awk '{print $NF}')
setsid ~/scripts/qutebrowser/mpv.sh "$Url" >/dev/null 2>&1 &
