# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# ENV

export PATH="/home/mikimasta/.juliaup/bin:/home/mikimasta/.sdkman/candidates/maven/current/bin:/home/mikimasta/.sdkman/candidates/gradle/current/bin:/home/mikimasta/.cargo/bin:/home/mikimasta/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games:/home/mikimasta/.local/bin:/home/mikimasta/.local/bin" 
export _JAVA_AWT_WM_NONREPARENTING=1
export SHELL="/bin/bash"
export EDITOR="vim"
export LEDGER_FILE="ledger.ledger"
export R_HOME="/usr/lib/R"
export XDG_CURRENT_DESKTOP="sway"
export MOZ_ENABLE_WAYLAND=1

# ssh-agent
eval $(ssh-agent -s)

# sway
test -z "$DISPLAY" -a -z "$WAYLAND_DISPLAY" -a -n "$XDG_VTNR" && test 1 -eq "$XDG_VTNR" && QT_QPA_PLATFORM=wayland SDL_VIDEODRIVER=wayland XDG_SESSION_TYPE=wayland exec sway

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
    *:/home/mikimasta/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/mikimasta/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
