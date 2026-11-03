# shellcheck shell=bash
if [ -n "$(fc-list : family 2>/dev/null | grep IosevkaComfy || true)" ]; then
    log "Iosevka Comfy already installed"
    return 0
fi
git_sync https://github.com/gawmk/iosevka-comfy-patched "$HOME/source/iosevka-comfy-patched"
sudo install -Dm644 -t /usr/share/fonts/iosevka-comfy "$HOME"/source/iosevka-comfy-patched/*.ttf
fc-cache -f
