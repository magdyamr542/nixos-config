#!/usr/bin/env bash

# Increase or decrease brightness by 2%.
if [ "$1" == "up" ]; then
  brightnessctl --quiet set +2%
elif [ "$1" == "down" ]; then
  brightnessctl --quiet set 2%-
fi

# show a notification with the new brightness level
brightness=$(brightnessctl --machine-readable info | cut -d, -f4)
notify-send -t 1500 "Brightness: $brightness"
