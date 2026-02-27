#!/bin/bash
# A simple bar visualizer using characters
cava -p ~/.config/hypr/cava-lock.conf | while read -r line; do
    echo "$line" | sed 's/0/ /g; s/1/./g; s/2/./g; s/3/o/g; s/4/o/g; s/5/O/g; s/6/O/g; s/7/X/g'
done
