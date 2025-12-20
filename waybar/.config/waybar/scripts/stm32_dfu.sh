#!/bin/bash
# 🧠 CS Logic: Check for STMicroelectronics DFU VID/PID
# $VID = 0483, $PID = df11

if lsusb -d 0483:df11 >/dev/null; then
  # Output for Waybar: 🔌 + Clean Text
  echo "{\"text\": \"󰈷 STM32 DFU\", \"class\": \"active\"}"
else
  # Output nothing to keep the bar clean 🌊
  echo "{\"text\": \"\", \"class\": \"none\"}"
fi
