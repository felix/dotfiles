#!/bin/sh

[ -e $HOME/.aliases ] && source $HOME/.aliases

dcu(){ docker-compose pull "$1" && docker-compose up -d "$1" && dcl "$1"; }

calc(){ printf 'scale=2;%s\n' "$*" |bc; }

# ssh() {
#     tmux rename-window "$*"
#     command ssh "$@"
#     tmux rename-window "${SHELL/*\//}"
# }

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  ssh-add
fi
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock

GPG_TTY=$(tty)
export GPG_TTY

SCREEN_PATH=$(command -v screen)
TMUX_PATH=$(command -v tmux)

if [ "$SHOWED_MUX_MESSAGE" != "true" ]; then
    if [ -x "$SCREEN_PATH" ]; then
        detached_screens=$(screen -list |grep Detached)
        [ ! -z "$detached_screens" ] && printf '\nDetached Screen: %s\n' "$detached_screens"
    fi
    if [ -x "$TMUX_PATH" ]; then
        detached_tmux=$(tmux ls 2> /dev/null)
        [ ! -z "$detached_tmux" ] && printf '\nDetached Tmux: %s\n' "$detached_tmux"
    fi
    export SHOWED_MUX_MESSAGE="true"
fi
