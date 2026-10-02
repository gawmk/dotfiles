
### KEYBOARD ###
setxkbmap -option ctrl:nocaps

### MOUSE ###
xinput set-prop "ELAN0678:00 04F3:3195 Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "HP 430 Wireless Mouse" "libinput Accel Profile Enabled" 0, 1
xinput set-prop "HP 430 Wireless Mouse" "libinput Accel Speed" -0.1

### MISC ###
xset -b #sysbell
xrdb -merge ~/.Xresources &
flameshot &

### VISUAL ###
redshift -l 47.36:8.55 -t 6500K:3500K &
feh --bg-scale ~/sync/multimedia/pics/wallpapers/forest.jpg &

### MONITORS ###
xrandr --output HDMI-A-0  \
    --mode 2560x1440 \
    --rate 120 &

xset -dpms
xset s off
xset s noblank

xss-lock -- slock &

### WM ETC ###
dunst &
picom --backend glx &
exec dwmblocks &
while type dwm >/dev/null ; do dwm && continue || break ;done 
