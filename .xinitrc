
### KEYBOARD ###
setxkbmap -option ctrl:nocaps

### MOUSE ###
xinput set-prop "pointer:HP HP 430 Mouse" "libinput Accel Profile Enabled" 0 1
xinput set-prop "pointer:HP HP 430 Mouse" "libinput Accel Speed" -0.1

xinput set-prop "pointer:HP 430 Wireless Mouse" "libinput Accel Profile Enabled" 0 1
xinput set-prop "pointer:HP 430 Wireless Mouse" "libinput Accel Speed" -0.1


xinput set-prop "pointer:Razer Razer DeathAdder V2" "libinput Accel Profile Enabled" 0 1
xinput set-prop "pointer:Razer Razer DeathAdder V2" "libinput Accel Speed" 0.4

xinput set-prop "pointer:SynPS/2 Synaptics TouchPad" "libinput Accel Profile Enabled" 0 1
xinput set-prop "pointer:SynPS/2 Synaptics TouchPad" "libinput Accel Speed" 1

### MISC ###
xset -b #sysbell
xrdb -merge ~/.Xresources &
lxpolkit &
xss-lock -- slock &
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

### WM ETC ###
dunst &
picom --backend glx &
exec dwmblocks &
while type dwm >/dev/null ; do dwm && continue || break ;done 
