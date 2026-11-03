# laptop
HOST_PKGS="tlp brightnessctl"
HOST_SERVICES="tlp"

WALLPAPER_DIR="$HOME/sync/multimedia/pics/wallpapers"

host_input() {
    xinput set-prop "ELAN0678:00 04F3:3195 Touchpad" "libinput Tapping Enabled" 1
    xinput set-prop "HP 430 Wireless Mouse" "libinput Accel Profile Enabled" 0, 1 2>/dev/null
    xinput set-prop "HP 430 Wireless Mouse" "libinput Accel Speed" -0.1 2>/dev/null
}

host_monitors() {
    # external monitor if plugged in
    local hdmi
    hdmi=$(xrandr -q | awk '$2 == "connected" && $1 ~ /^HDMI/ {print $1; exit}')
    [ -n "$hdmi" ] && xrandr --output "$hdmi" --mode 2560x1440 --rate 120
}
