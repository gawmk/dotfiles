# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# ENV

export PATH="/home/gawmk/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/gawmk/.local/bin:/home/gawmk/.local/bin" 
export SHELL="/bin/bash"
export EDITOR="vim"
export LEDGER_FILE="ledger.ledger"
export BROWSER="/usr/bin/firefox"
export MOZ_ENABLE_WAYLAND=1
export GTK_THEME="Gruvbox-Material-Dark"

# ssh-agent
eval $(ssh-agent -s)

# imwheel

if [[ -f "usr/bin/imwheel" ]]; then
    imwheel
fi

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi






