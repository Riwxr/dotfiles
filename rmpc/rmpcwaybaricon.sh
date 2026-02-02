#!/usr/bin/env bash

state=$(rmpc status | jq -r '.state')

if [ "$state" == "Play" ]; then
	echo ""
elif [ "$state" == "Pause" ]; then
	echo ""
else
	echo ""
fi
