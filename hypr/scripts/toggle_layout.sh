#!/usr/bin/env bash

WS=$(hyprctl activeworkspace -j | jq -r '.id')
STATE_FILE="/tmp/hypr-layout-ws-${WS}"

if [ -f "$STATE_FILE" ] && grep -q "scrolling" "$STATE_FILE"; then
    NEW_LAYOUT="dwindle"
else
    NEW_LAYOUT="scrolling"
fi

hyprctl keyword general:layout "$NEW_LAYOUT"
echo "$NEW_LAYOUT" > "$STATE_FILE"
notify-send "Hyprland Layout" "Workspace $WS → $NEW_LAYOUT"