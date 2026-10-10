#!/usr/bin/env bash
set -euo pipefail

device=@DEFAULT_AUDIO_SINK@
title=Volume
icon=audio-volume-high
case "${1:-}" in
    up) wpctl set-volume -l 1 "$device" 5%+ ;;
    down) wpctl set-volume "$device" 5%- ;;
    mute) wpctl set-mute "$device" toggle ;;
    mic-mute)
        device=@DEFAULT_AUDIO_SOURCE@
        title=Microphone
        icon=audio-input-microphone
        wpctl set-mute "$device" toggle
        ;;
    *) exit 2 ;;
esac
status=$(wpctl get-volume "$device")
percent=$(awk '{printf "%.0f", $2 * 100}' <<< "$status")
if [[ "$status" == *MUTED* ]]; then
    message="Muted ($percent%)"
else
    message="$percent%"
fi
notify-send -a "Audio controls" -i "$icon" -t 1200 \
    -h string:x-canonical-private-synchronous:audio-controls \
    -h int:value:"$percent" "$title" "$message"
