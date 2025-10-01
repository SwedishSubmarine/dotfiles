#!/bin/sh
devices=$(bluetoothctl devices Paired | sed -n 's/^Device \(\S*\) \(.*\)/\1|\2/p')
selected=$(echo "$devices" | cut -d '|' -f 2 | rofi -dmenu -theme-str 'inputbar {enabled: false; }' -theme-str 'listview { margin: 0 0 0; }' -p "Connect to...")
if [ "$selected" != "" ]; then
    bluetoothctl connect $(echo "$devices" | grep "$selected" | cut -d '|' -f 1) \
        && notify-send "Connected to $selected" \
        || notify-send "Failed to connect to $selected"
fi
