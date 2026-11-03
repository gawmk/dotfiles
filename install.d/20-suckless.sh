# shellcheck shell=bash
# my forks: build as user, install to /usr/local
SRC="$HOME/source"
mkdir -p "$SRC"
for repo in dwm st dmenu; do
    git_sync "https://github.com/gawmk/$repo" "$SRC/$repo"
    log "building $repo"
    ( cd "$SRC/$repo"
      make clean >/dev/null 2>&1 || true
      rm -f config.h
      make >/dev/null
      sudo make install >/dev/null )
done
