# shared defaults; per-machine overrides live in ~/dotfiles/hosts/$(hostname).sh
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
[ -f "$DOTFILES/hosts/$(hostname).sh" ] && . "$DOTFILES/hosts/$(hostname).sh"
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/sync/media/pics/wallpapers}"
WALLPAPER="${WALLPAPER:-$WALLPAPER_DIR/forest.jpg}"

### KEYBOARD ###
setxkbmap -option ctrl:nocaps
setxkbmap "${KB_LAYOUT:-us}"

### INPUT ###
type host_input >/dev/null 2>&1 && host_input

### MISC ###
xset -b #sysbell
xrdb -merge ~/.Xresources &
flameshot &

### VISUAL ###
redshift -l 47.36:8.55 -t 6500K:3500K &
feh --bg-scale "$WALLPAPER" &

### MONITORS ###
type host_monitors >/dev/null 2>&1 && host_monitors &

xset -dpms
xset s off
xset s noblank

xss-lock -- slock &

### WM ETC ###
dunst &
picom --backend glx &
qs &  # status bar (~/.config/quickshell); dwm picks it up as its bar via anybar
while type dwm >/dev/null ; do dwm && continue || break ;done
