#!/usr/bin/env bash

signs=( "" "󰛄" "" "" "󰛄" "󰛄" "" )
sign=(       )

id=1

while true; do
	for i in ${signs[@]}; do
		notify-send --replace-id=$id -a toss "$i"
		sleep .12
	done
done
