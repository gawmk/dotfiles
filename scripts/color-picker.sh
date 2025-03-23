#!/bin/bash

# Capture color using slurp + grim + convert
color_output=$(grim -g "$(slurp -p)" -t ppm - | convert - -format '%[pixel:p{0,0}]' txt:-)

# Copy full output to clipboard
echo "$color_output" | wl-copy

# Extract hex and RGB from ImageMagick-style output
# Example line: 0,0: (245,222,179)  #f5deb3  rgb(245,222,179)
hex=$(echo "$color_output" | grep -oE '#[0-9A-Fa-f]{6}')
rgb=$(echo "$color_output" | grep -oE 'rgb\([^)]+\)')

# Send notification with both formats
notify-send "🎨 Color picked!" "HEX: $hex\nRGB: $rgb\n(Copied full value to clipboard)"
