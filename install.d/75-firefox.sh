# shellcheck shell=bash
# firefox/: extensions via policies.json (system-wide), user.js + chrome/ linked into the profile
src="$DOTFILES/firefox"

if ! cmp -s "$src/policies.json" /etc/firefox/policies/policies.json; then
    sudo install -Dm644 "$src/policies.json" /etc/firefox/policies/policies.json
    log "installed /etc/firefox/policies/policies.json (extensions)"
fi

# the profile folder has a random name; take the default one from profiles.ini
profile=""
for base in "$HOME/.config/mozilla/firefox" "$HOME/.mozilla/firefox"; do
    ini="$base/profiles.ini"
    [ -f "$ini" ] || continue
    # [Install...] sections name the profile this Firefox install actually uses
    rel=$(awk -F= '/^\[Install/{s=1;next} /^\[/{s=0} s&&$1=="Default"{print $2; exit}' "$ini")
    [ -n "$rel" ] || rel=$(awk -F= '/^Path=/{p=$2} /^Default=1/{print p; exit}' "$ini")
    [ -n "$rel" ] && [ -d "$base/$rel" ] && { profile="$base/$rel"; break; }
done
if [ -z "$profile" ]; then
    warn "no Firefox profile yet: start Firefox once, close it, then run ./install --only firefox"
    return 0
fi

backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)/firefox"
for f in user.js chrome; do
    [ "$(readlink "$profile/$f")" = "$src/$f" ] && continue
    if [ -e "$profile/$f" ] || [ -L "$profile/$f" ]; then
        mkdir -p "$backup"; mv "$profile/$f" "$backup/"
        warn "moved existing $f from the Firefox profile to $backup/"
    fi
    ln -s "$src/$f" "$profile/$f"
done
log "Firefox profile: ${profile/#$HOME/~} (restart Firefox to pick up changes)"
