#!/usr/bin/env bash

WALL_DIR="$HOME/Pictures/Pictures/wallpapers"
THUMB_DIR="$HOME/.cache/wallthumbs"
CACHE_FILE="$HOME/.cache/wall_rofi_list.txt"
LOCK_FILE="/tmp/wall_gen.lock"
mkdir -p "$THUMB_DIR"

# --- 1. ATOMIC CACHE GENERATOR ---
generate_list() {
    # Guard: Don't run if another instance is already generating
    if [ -f "$LOCK_FILE" ]; then return; fi
    touch "$LOCK_FILE"

    local tmp_cache="${CACHE_FILE}.tmp"
    
    find "$WALL_DIR" -maxdepth 1 -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) -printf "%T@ %f\n" | \
    sort -n | \
    cut -d' ' -f2- | \
    while read -r name; do
        full_path="$WALL_DIR/$name"
        hash=$(cksum <<< "$full_path" | cut -f1 -d' ')
        thumb="$THUMB_DIR/$hash.jpg"
        
        echo "$name|$thumb"
        
        if [ ! -f "$thumb" ]; then
            # Limits thumbnailing to 1 at a time to save CPU
            magick "$full_path" -thumbnail 300x300^ -gravity center -extent 300x300 "$thumb" >/dev/null 2>&1
        fi
    done > "$tmp_cache"

    mv "$tmp_cache" "$CACHE_FILE"
    rm "$LOCK_FILE"
}

# --- 2. INITIAL CHECK ---
if [ ! -f "$CACHE_FILE" ]; then
    generate_list
fi

# --- 3. LAUNCH ROFI ---
# Removed -selected-row so it opens at the beginning
chosen=$(awk -F'|' '{printf "%s\0icon\x1f%s\n", $1, $2}' "$CACHE_FILE" | \
    rofi -dmenu -i -show-icons -theme-str '
window { width: 97.5%; location: south; anchor: south; margin: 10px; }
listview { lines: 1; columns: 10; fixed-height: true; }
element { orientation: vertical; children: [ element-icon ]; }
element-icon { size: 175px; horizontal-align: 0.5; }
element-text { enabled: false; }
inputbar { enabled: false; }
')

# --- 4. EXECUTE SELECTION ---
if [ -n "$chosen" ]; then
    full="$WALL_DIR/$chosen"
    swww img "$full" --transition-type grow --transition-duration 2 &
    (
        ln -sf "$full" "$HOME/.cache/current_wallpaper.png"
        matugen image "$full" --mode dark --type scheme-content
        blurred_wall="$HOME/.cache/blurred_wallpaper.png"
        magick "$full" -blur 0x5 "$blurred_wall"
        swww img -n overlay "$blurred_wall" --transition-type grow
    ) &
fi

# --- 5. BACKGROUND REFRESH ---
generate_list &