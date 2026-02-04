
#!/usr/bin/env bash

# Function to send OSD notification
notify_osd() {
    local message="$1"
    swayosd-client --custom-message "$message"
}

# Get Android IP from Tailscale
ANDROID_IP=$(tailscale status | awk '/a21s/ {print $1}')
notify_osd "Android IP: $ANDROID_IP retrieved"
sleep 0.5

# Workspace 1: kitty
hyprctl dispatch workspace 1
hyprctl dispatch exec kitty 
hyprctl dispatch exec "kitty -e nvim"
sleep 0.4
hyprctl dispatch workspace 2

sleep 1
# Check if device is nearby before connecting
DEVICE_NAME="vivo V40e"
if nmcli device wifi list | grep -q "$DEVICE_NAME"; then
    nmcli connection up "$DEVICE_NAME"
    notify_osd "Connected to $DEVICE_NAME"
else
    notify-send "Device $DEVICE_NAME not found nearby, skipping connection"
fi
sleep 9

# Connect to Android over ADB
adb connect $ANDROID_IP:5555
notify_osd "ADB connected"
sleep 4

# Enable Bluetooth on Android
adb -s $ANDROID_IP:5555 shell svc bluetooth enable
notify_osd "Bluetooth enabled on Android"
sleep 4
~/scripts/brightness.sh 0
# Power on local Bluetooth and connect
bluetoothctl power on
bluetoothctl connect 98:B8:BC:59:24:E6
notify_osd "Bluetooth connected to A21s"

