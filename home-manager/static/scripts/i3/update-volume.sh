#!/bin/sh

getdefaultsinkname() {
    pacmd stat | awk -F": " '/^Default sink name: /{print $2}'
}

getdefaultsinkvol() {
    pacmd list-sinks |
        awk '/^\s+name: /{indefault = $2 == "<'$(getdefaultsinkname)'>"}
            /^\s+volume: / && indefault {print $5; exit}' |
        awk -F"%" '{print $1}'
}


# increase or decrease brightness by 10%
if [ "$1" == "up" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ +10%
elif [ "$1" == "down" ]; then
  pactl set-sink-volume @DEFAULT_SINK@ -10%
fi

# show a notification with the new volume level
volume=$(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | tr -d '\n')
notify-send -t 1500 "Volume: $volume"
