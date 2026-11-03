# shellcheck shell=bash
host_file="$DOTFILES/hosts/$(hostname).sh"
if [ -f "$host_file" ]; then
    log "host config: hosts/$(hostname).sh"
else
    cp "$DOTFILES/hosts/template.sh" "$host_file"
    warn "created hosts/$(hostname).sh from the template; edit it (keyboard, monitors, input) and commit it"
fi
