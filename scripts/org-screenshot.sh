#!/bin/bash

# Temp screenshot file
tmpfile="/tmp/screenshot_tmp_$$.png"

# Get region using slurp
region=$(slurp -d)

# Exit if no region selected (e.g., Escape pressed)
if [[ -z "$region" ]]; then
    exit 1
fi

# Take screenshot
grim -g "$region" "$tmpfile"

# Prompt for filename using tofi
filename=$(echo "" | tofi --prompt-text "Screenshot name: " --require-match=false)

# If user cancels or enters nothing, fallback to timestamp
if [[ -z "$filename" ]]; then
    filename="ss_$(date +'%Y-%m-%d_%H%M%S')"
fi

# Final path
dest=~/org/notes/img/${filename}.png

# Move screenshot and copy to clipboard
mv "$tmpfile" "$dest"
wl-copy < "$dest"

# Notify (optional)
notify-send "📸 Screenshot saved!" "$dest"
