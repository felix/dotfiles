#!/bin/sh

#hostname=$(hostname |cut -d. -f1)

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
alias fsl="fossil"
# Mail
alias mutt-freestyle='neomutt -F ~/.mutt/muttrc.freestyle'
alias mutt-userspace='neomutt -F ~/.mutt/muttrc.userspace'
alias mutt-seer='neomutt -F ~/.mutt/muttrc.seersec'
# Docker
alias dockerm='docker-machine'
alias dockerc='docker-compose'
alias dcl='docker-compose logs -t -f --tail=100'
dcu(){ docker-compose pull "$1" && docker-compose up -d "$1" && dcl "$1"; }

# maths in the CLI
calc(){ printf 'scale=2;%s\n' "$*" |bc; }

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
fi
export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
for i in $(ls $HOME/.ssh/*.pub); do
    ssh-add -l |grep -q $(basename "${i%%.pub}") ||ssh-add "${i%%.pub}"
done

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

#if [ -e "$HOME/bin/chruby.sh" ]; then
#    # shellcheck source=chruby.sh
#    . "$HOME/bin/chruby.sh"
#    #source /usr/local/share/chruby/auto.sh
#    chruby system
#fi
