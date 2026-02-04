#!/usr/bin/env bash
SSID1=
SSID2=
SSID3=""
SSID5="Riwxr"
SSID4="Galaxy A21s24E7"

nmcli device wifi rescan >/dev/null 2>&1

if nmcli device wifi list | grep -q "$SSID1"; then

if nmcli device wifi list | grep -q "$SSID2"; then

if nmcli device wifi list | grep -q "$SSID3"; then

if nmcli device wifi list | grep -q "$SSID4"; then

if nmcli device wifi list | grep -q "$SSID5"; then
