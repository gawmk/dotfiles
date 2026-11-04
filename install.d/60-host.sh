# shellcheck shell=bash
host_file="$DOTFILES/hosts/$(uname -n).sh"
if [ -f "$host_file" ]; then
    log "host config: hosts/$(uname -n).sh"
else
    cp "$DOTFILES/hosts/template.sh" "$host_file"
    warn "created hosts/$(uname -n).sh from the template; edit it (keyboard, monitors, input) and commit it"
fi
