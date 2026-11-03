# laptop — Debian
HOST_PKGS="tlp"
HOST_SERVICES="tlp"

WALLPAPER_DIR="$HOME/sync/multimedia/pics/wallpapers"

host_input() {
    xinput set-prop "ELAN0678:00 04F3:3195 Touchpad" "libinput Tapping Enabled" 1
    xinput set-prop "HP 430 Wireless Mouse" "libinput Accel Profile Enabled" 0, 1 2>/dev/null
    xinput set-prop "HP 430 Wireless Mouse" "libinput Accel Speed" -0.1 2>/dev/null
}

host_monitors() {
    # external monitor if plugged in
    if xrandr -q | grep -q '^HDMI-A-0 connected'; then
        xrandr --output HDMI-A-0 --mode 2560x1440 --rate 120
    fi
}
