# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# ENV

export PATH="/home/gawmk/.juliaup/bin:/home/gawmk/.sdkman/candidates/maven/current/bin:/home/gawmk/.sdkman/candidates/gradle/current/bin:/home/gawmk/.cargo/bin:/home/gawmk/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/gawmk/.local/bin:/home/gawmk/.local/bin" 
export _JAVA_AWT_WM_NONREPARENTING=1
export SHELL="/bin/bash"
export EDITOR="vim"
export LEDGER_FILE="ledger.ledger"
export R_HOME="/usr/lib/R"
export XDG_CURRENT_DESKTOP="sway"
export BROWSER="/home/gawmk/.local/bin/qutebrowser"
export MOZ_ENABLE_WAYLAND=1

# ssh-agent
eval $(ssh-agent -s)

# imwheel

if [[ -f "usr/bin/imwheel" ]]; then
    imwheel
fi

# remove bell sound
sudo rmmod pcspkr

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
# cargo
. "$HOME/.cargo/env"



# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/gawmk/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/gawmk/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<

# Created by `pipx` on 2025-05-21 09:14:18
export PATH="$PATH:/home/gawmk/.local/bin"
