#!/usr/bin/env bash
options="Heads
Tails"
output=$(printf "%s\n" "$options" | shuf -n 1)
echo "$output"
