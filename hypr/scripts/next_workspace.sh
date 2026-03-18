#!/usr/bin/env bash

# Usage: cooldown <lock_name> <duration_ms> <command...>

LOCK_FILE="/tmp/hypr_lock_$1"
COOLDOWN_MS=$2
shift 2
COMMAND="hyprctl dispatch workspace r+1"

# Check if lock exists
if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

# Create lock and run command
touch "$LOCK_FILE"
exec $COMMAND &

# Remove lock after cooldown
sleep "$(echo "scale=3; $COOLDOWN_MS / 1000" | bc)"
rm "$LOCK_FILE"