# shellcheck shell=bash
# symlink the repo into ~ with stow; real files in the way are moved to a backup dir
command -v stow >/dev/null || pkg_install stow
backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

conflicts=$( { stow --no --verbose=1 --dir="$DOTFILES" --target="$HOME" --restow . 2>&1 || true; } \
    | sed -n 's/.*existing target \(is not owned by stow\|is neither a link nor a directory\): //p;
               s/.*over existing target \(.*\) since.*/\1/p')
for f in $conflicts; do
    mkdir -p "$backup/$(dirname "$f")"
    mv "$HOME/$f" "$backup/$f"
    warn "moved existing ~/$f to $backup/"
done

stow --dir="$DOTFILES" --target="$HOME" --restow .
log "linked $DOTFILES into $HOME"
