# shellcheck shell=bash
sudo systemctl enable --now NetworkManager.service 2>/dev/null || warn "could not enable NetworkManager"
systemctl --user enable --now syncthing.service 2>/dev/null || warn "could not enable syncthing (user service)"

# extra system services for this machine only (HOST_SERVICES in hosts/$(hostname).sh)
for svc in $(host_var HOST_SERVICES); do
    sudo systemctl enable --now "$svc" 2>/dev/null || warn "could not enable $svc"
done
