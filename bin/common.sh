#!/bin/sh

hostname=$(hostname -s)

alias ll='ls -l'
alias la='ls -A'
alias lh='ls -lh'
alias l='ls -CF'
alias h='history |grep'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias wget="wget --timeout 10 -c"
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"
alias mutt-freestyle='neomutt -F ~/.mutt/muttrc.freestyle'
alias mutt-userspace='neomutt -F ~/.mutt/muttrc.userspace'

# maths in the CLI
calc(){ printf 'scale=2;%s\n' "$*" |bc;}

# Sometimes I need AltGr, make sure it is the right Alt key
[ "$hostname" = "beastie" ] && xmodmap -e "keycode 113 = Alt_R" -e "remove mod1 = Alt_R" -e "add mod3 = Alt_R"

SSH_ENV="$HOME/.ssh/environment"
SSH_AGENT=$(which ssh-agent)
SSH_ADD=$(which ssh-add)

start_ssh_agent() {
    echo "Initializing new SSH agent..."
    $SSH_AGENT | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    # shellcheck disable=SC1090
    . "${SSH_ENV}" >/dev/null
    $SSH_ADD
}

if [ -z "$SSH_AUTH_SOCK" ]; then
    if [ -x "$SSH_AGENT" ]; then
        # source SSH settings, if applicable
        if [ -f "${SSH_ENV}" ]; then
            # shellcheck disable=SC1090
            . "${SSH_ENV}" >/dev/null
            uid=$(id -u)
            [ "$(pgrep -u "$uid" ssh-agent)" = "$SSH_AGENT_PID" ] || { start_ssh_agent; }
        else
            start_ssh_agent;
        fi
    fi
fi

GPG_TTY=$(tty)
export GPG_TTY

SCREEN_PATH=$(which screen)
TMUX_PATH=$(which tmux)

if [ "$SHOWED_MUX_MESSAGE" != "true" ]; then
    if [ -x "$SCREEN_PATH" ]; then
        detached_screens=$(screen -list | grep Detached)
        [ ! -z "$detached_screens" ] && printf '%s\n' "$detached_screens"
    fi
    if [ -x "$TMUX_PATH" ]; then
        detached_tmux=$(tmux ls 2> /dev/null)
        [ ! -z "$detached_tmux" ] && printf '%s\n' "$detached_tmux"
    fi
    printf '%s\n' "$detached_screens"
    export SHOWED_MUX_MESSAGE="true"
fi

if [ -e "$HOME/bin/chruby.sh" ]; then
    # shellcheck source=chruby.sh
    . "$HOME/bin/chruby.sh"
    #source /usr/local/share/chruby/auto.sh
    chruby system
fi

# shellcheck disable=SC1094
[ -e /usr/local/bin/virtualenvwrapper.sh ] && . /usr/local/bin/virtualenvwrapper.sh
