#!/bin/bash
# Get song info, truncate if too long, and handle "nothing playing"
INFO=$(playerctl metadata --format '{{title}} - {{artist}}' 2>/dev/null)

if [ -z "$INFO" ]; then
    echo "Silence..."
else
    # Truncate to 40 chars so it doesn't break your layout
    echo "$INFO" | cut -c1-40
fi
