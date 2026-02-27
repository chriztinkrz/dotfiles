#!/bin/bash
# simple OSD via mako

TYPE="$1"
VALUE="$2"

case "$TYPE" in
    volume)
        ICON="🔊"
        # Convert fraction to percent properly
        if [[ "$VALUE" =~ ^[0-9.]+$ ]]; then
            VALUE=$(awk "BEGIN { printf \"%d\", $VALUE * 100 }")
        fi
        MSG="${ICON} Volume: ${VALUE}%"
        ;;
    mute)
        ICON="🔇"
        MSG="${ICON} Muted"
        ;;
    brightness)
        ICON="🔆"
        if [[ "$VALUE" =~ ^[0-9.]+$ ]]; then
            VALUE=$(awk "BEGIN { printf \"%d\", $VALUE * 100 }")
        fi
        MSG="${ICON} Brightness: ${VALUE}%"
        ;;
    *)
        exit 1
        ;;
esac

notify-send -a "OSD" -u normal "$MSG"
