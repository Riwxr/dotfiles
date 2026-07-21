#! /usr/bin/env bash

blank=$(printf "\n\n ")
time=$(date +"   %I:%M")
date=$(date +"  %d-%b-%Y")
day=$(date +"  %A")

notify-send " ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄$blank$time$blank$date$blank$day$blank▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀" -a toss -r 6
