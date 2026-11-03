# shellcheck shell=bash
# helpers shared by install steps

log()     { printf '\033[1;32m::\033[0m %s\n' "$*"; }
warn()    { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()     { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }
section() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

detect_distro() {
    if [ -f /etc/arch-release ] || command -v pacman >/dev/null; then DISTRO=arch
    elif [ -f /etc/debian_version ]; then DISTRO=debian
    else die "unsupported distro (need Arch-based or Debian-based)"; fi
    export DISTRO
}

# print a variable from this machine's host file (empty if unset or no file)
host_var() {
    local f="$DOTFILES/hosts/$(hostname).sh"
    [ -f "$f" ] || return 0
    ( . "$f" >/dev/null 2>&1; eval "printf '%s' \"\${$1:-}\"" )
}

# read a package list, dropping comments and blank lines
pkglist() { sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$@" | tr -s ' \t' '\n' | sed '/^$/d'; }

pkg_install() { # pkg_install name...
    [ $# -gt 0 ] || return 0
    case "$DISTRO" in
        arch)   sudo pacman -S --needed --noconfirm "$@" ;;
        debian)
            local avail=() p
            for p in "$@"; do
                if apt-cache show "$p" >/dev/null 2>&1; then avail+=("$p")
                else warn "not in apt repos, skipping: $p"; fi
            done
            sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "${avail[@]}" ;;
    esac
}

# clone or fast-forward a repo
git_sync() { # git_sync url dir [ref]
    local url="$1" dir="$2" ref="${3:-}"
    if [ -d "$dir/.git" ]; then
        git -C "$dir" pull --ff-only --quiet || warn "$dir: could not fast-forward, leaving as is"
    else
        git clone --quiet ${ref:+--branch "$ref"} "$url" "$dir"
    fi
}
