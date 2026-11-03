# shellcheck shell=bash
if [ "$NO_PKGS" = 1 ]; then log "skipping packages (--no-pkgs)"; return 0; fi

case "$DISTRO" in
    arch)   sudo pacman -Syu --noconfirm ;;
    debian) sudo apt-get update ;;
esac
mapfile -t pkgs < <(pkglist "$DOTFILES/install.d/packages/$DISTRO.txt")
pkg_install "${pkgs[@]}"

# starship isn't packaged everywhere
if ! command -v starship >/dev/null; then
    log "installing starship to ~/.local/bin"
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
fi
