#!/bin/bash

# Define output names
laptop="eDP-1"
hdmiMonitor="HDMI-A-1"

# Map workspaces 1–9 to HDMI monitor
for i in {1..9}; do
    swaymsg "workspace $i; move workspace to output $laptop"
done

# Map workspace 10 to laptop screen
swaymsg "workspace 10; move workspace to output $hdmiMonitor"
