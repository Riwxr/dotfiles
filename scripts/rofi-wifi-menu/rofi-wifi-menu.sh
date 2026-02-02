#!/usr/bin/env bash


wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="󰖪  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="󰖩  Enable Wi-Fi"
fi
Rescan="󱛄  Rescan Wi-Fi"
Me="󰫤  Riwxr  --"
Mom="󰫤  Vivo V40e  --"
Bapu="󰫤  Galaxy A21s24E7  --"

# Use rofi to select wifi network
chosen_network=$(echo -e "$Me\n$Mom\n$Bapu\n$Rescan\n$toggle\n$wifi_list" | uniq -u | rofi -dmenu -p "Wi-Fi SSID: " )
# Get name of connection
read -r chosen_id <<< "${chosen_network:3}"

if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
elif [ "$chosen_network" = "󰫤  Riwxr  --" ]; then
	nmcli connection up "Riwxr"  && notify-send "NMCLI" "Connected to Riwxr"
elif [ "$chosen_network" = "󰫤  Vivo V40e  --" ]; then
	nmcli connection up "vivo V40e" && notify-send "NMCLI" "Connected to Vivo V40e"
elif [ "$chosen_network" = "󰫤  Galaxy A21s24E7  --" ]; then
	nmcli connection up "Galaxy A21s24E7"  && notify-send "NMCLI" "Connected to Galaxy A21s24E7"
elif [ "$chosen_network" = "󱛄  Rescan Wi-Fi" ]; then
	nmcli device wifi rescan
	sleep 2 && ~/scripts/rofi-wifi-menu/rofi-wifi-menu.sh
else
	# Message to show when connection is activated successfully
  	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" | grep "successfully" && notify-send "Connection Established" "$success_message"
	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -p "Password: " -theme ~/.cache/wal/darkrofi.rasi )
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
    fi
fi
