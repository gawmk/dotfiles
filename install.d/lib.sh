# shellcheck shell=bash
# helpers shared by install steps

log()     { printf '\033[1;32m::\033[0m %s\n' "$*"; }
warn()    { printf '\033[1;33m!!\033[0m %s\n' "$*" >&2; }
die()     { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }
section() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

require_arch() {
    command -v pacman >/dev/null || die "Arch-based systems only (no pacman found)"
}

# print a variable from this machine's host file (empty if unset or no file)
host_var() {
    local f="$DOTFILES/hosts/$(uname -n).sh"
    [ -f "$f" ] || return 0
    ( . "$f" >/dev/null 2>&1; eval "printf '%s' \"\${$1:-}\"" )
}

# read a package list, dropping comments and blank lines
pkglist() { sed -e 's/#.*//' -e '/^[[:space:]]*$/d' "$@" | tr -s ' \t' '\n' | sed '/^$/d'; }

pkg_install() { # pkg_install name...
    [ $# -gt 0 ] || return 0
    sudo pacman -S --needed --noconfirm "$@"
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
