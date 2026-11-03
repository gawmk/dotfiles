# bash reads this instead of ~/.profile when it exists (Arch's /etc/skel ships one),
# so hand over to ~/.profile, which also sources ~/.bashrc
[ -f "$HOME/.profile" ] && . "$HOME/.profile"
