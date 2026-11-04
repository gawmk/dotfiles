# shellcheck shell=bash
host_file="$DOTFILES/hosts/$(uname -n).sh"
if [ -f "$host_file" ]; then
    log "host config: hosts/$(uname -n).sh"
else
    cp "$DOTFILES/hosts/template.sh" "$host_file"
    warn "created hosts/$(uname -n).sh from the template; edit it (keyboard, monitors, input) and commit it"
fi

# system files for this machine: hosts/<host>/etc/... is copied to /etc/...
etc_dir="$DOTFILES/hosts/$(uname -n)/etc"
if [ -d "$etc_dir" ]; then
    reload_logind=0
    while IFS= read -r -d '' f; do
        rel="${f#"$etc_dir"/}"
        if ! cmp -s "$f" "/etc/$rel"; then
            sudo install -Dm644 "$f" "/etc/$rel"
            log "installed /etc/$rel"
            case "$rel" in systemd/logind.conf.d/*) reload_logind=1 ;; esac
        fi
    done < <(find "$etc_dir" -type f -print0)
    # HUP reloads logind's config without ending the session (a restart would)
    [ "$reload_logind" = 1 ] && sudo systemctl kill -s HUP systemd-logind
fi

# keyboard default for every X input device, including ones plugged in later
# (setxkbmap in .xinitrc only reaches devices present at login)
layout="$(host_var KB_LAYOUT)"; layout="${layout:-us}"
if ! localectl status | grep -q "X11 Layout: $layout\$" || ! localectl status | grep -q 'X11 Options: ctrl:nocaps$'; then
    sudo localectl --no-convert set-x11-keymap "$layout" pc105 "" ctrl:nocaps
    log "X keyboard default: $layout, ctrl:nocaps (applies from the next X start)"
fi
