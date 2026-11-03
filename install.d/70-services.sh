# shellcheck shell=bash
sudo systemctl enable --now NetworkManager.service 2>/dev/null || warn "could not enable NetworkManager"
systemctl --user enable --now syncthing.service 2>/dev/null || warn "could not enable syncthing (user service)"
