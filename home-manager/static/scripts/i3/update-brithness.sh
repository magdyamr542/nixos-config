#!/bin/bash

# increase or decrease brightness by 10%
if [ "$1" == "up" ]; then
  light -A 5
elif [ "$1" == "down" ]; then
  light -U 5 
fi

# show a notification with the new brightness level
brightness=$(light -G)
notify-send -t 1500  "Brightness: $brightness%"
