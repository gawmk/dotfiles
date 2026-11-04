# shellcheck shell=bash
if [ "$NO_PKGS" = 1 ]; then log "skipping packages (--no-pkgs)"; return 0; fi

sudo pacman -Syu --noconfirm
mapfile -t pkgs < <(pkglist "$DOTFILES/install.d/packages.txt")
pkg_install "${pkgs[@]}"

# extra packages for this machine only (HOST_PKGS in hosts/$(uname -n).sh)
read -ra host_pkgs <<<"$(host_var HOST_PKGS)"
[ ${#host_pkgs[@]} -gt 0 ] && pkg_install "${host_pkgs[@]}"
