# shellcheck shell=bash
sudo systemctl enable --now NetworkManager.service 2>/dev/null || warn "could not enable NetworkManager"
sudo systemctl enable --now bluetooth.service 2>/dev/null || warn "could not enable bluetooth"
systemctl --user enable --now syncthing.service 2>/dev/null || warn "could not enable syncthing (user service)"

# extra system services for this machine only (HOST_SERVICES in hosts/$(uname -n).sh)
for svc in $(host_var HOST_SERVICES); do
    sudo systemctl enable --now "$svc" 2>/dev/null || warn "could not enable $svc"
done

# ly login screen on tty2 (starts ~/.xinitrc); takes over from the tty2 getty after a reboot
if [ -f /usr/lib/systemd/system/ly@.service ]; then
    sudo systemctl disable getty@tty2.service 2>/dev/null || true
    sudo systemctl enable ly@tty2.service 2>/dev/null || warn "could not enable ly"
fi
