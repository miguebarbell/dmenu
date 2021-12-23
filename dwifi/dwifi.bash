#!/bin/sh
wifi=$(nmcli device wifi list | sed -n '1!p' | cut -b 9- | dmenu -p "Select Wifi: " -l 20 | cut -d' ' -f1)
pass=$(echo "" | dmenu -p "Enter password: ")
nmcli device wifi connect $wifi password $pass
