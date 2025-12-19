#!/usr/bin/env bash

# Options to display
options="󰐥 Shutdown\n󰜉 Reboot\n󰤄 Suspend\n󰈆 Logout"

# Launch rofi in dmenu mode
chosen=$(echo -e "$options" | rofi -dmenu -i -p "Power Menu" -theme ~/.config/rofi/launchers/type-2/style-2.rasi -config ~/.config/rofi/config.rasi)

# Logic to handle selection
case $chosen in
*Shutdown)
  systemctl poweroff
  ;;
*Reboot)
  systemctl reboot
  ;;
*Suspend)
  systemctl suspend
  ;;
*Logout)
  hyprctl dispatch exit
  ;; # Specific to Hyprland!
esac
