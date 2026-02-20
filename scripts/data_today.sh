#!/bin/bash

BYTES=$(vnstat -d --json | jq '[.interfaces[].traffic.day[0].rx, .interfaces[].traffic.day[0].tx] | add')

if [ "$BYTES" -lt 1073741824 ]; then
    awk "BEGIN {printf \"%.2f MB\", $BYTES/1024/1024}"
else
    awk "BEGIN {printf \"%.2f GB\", $BYTES/1024/1024/1024}"
fi
