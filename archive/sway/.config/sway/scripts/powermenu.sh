#!/bin/bash
#           _ _       _
# __      _(_) |_ ___| | ____ _
# \ \ /\ / / | __/ _ \ |/ / _` |
#  \ V  V /| | ||  __/   < (_| |
#   \_/\_/ |_|\__\___|_|\_\__, |
#                         |___/
# Witek3023
# https://github.com/Witek3023

options="⏻ Power Off\n Reboot\n⏾ Suspend\n󰗽 Logout"

choice=$(echo -e "$options" | fuzzel --dmenu --prompt="Power ❯ " -l 4 -w 25)

case "$choice" in
    "⏻ Power Off")
        systemctl poweroff
        ;;
    " Reboot")
        systemctl reboot
        ;;
    "⏾ Suspend")
        systemctl suspend
        ;;
    "󰗽 Logout")
        swaymsg exit
        ;;
    *)
        exit 0
        ;;
esac
