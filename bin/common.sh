alias ll='ls -l'
alias la='ls -A'
alias lh='ls -lh'
alias l='ls -CF'
alias h='history |grep'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias wget="wget --timeout 10 -c"
alias mutt-freestyle='mutt -F ~/.mutt/muttrc-freestyle'
alias mutt-userspace='mutt -F ~/.mutt/muttrc-userspace'
# maths in the CLI
calc(){ echo "scale=2;$@" | bc;}

# enable color support of ls
case "$OSTYPE" in
    linux*)
    alias ls="ls --color=auto"
    alias grep="grep --color=auto"
esac

GPG_AGENT=`which gpg-agent`
SSH_ADD=`which ssh-add`

start_ssh_agent() {
    echo "Initializing new SSH agent..."
    $SSH_AGENT | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" > /dev/null
    $SSH_ADD
}

if [ -z "$SSH_AUTH_SOCK" ]; then
    if [ -x "$GPG_AGENT" ]; then
        gpg-connect-agent /bye
        unset SSH_AGENT_PID
        if [ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]; then
            export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
        fi
        echo UPDATESTARTUPTTY |gpg-connect-agent >/dev/null 2>&1
    else
        SSH_ENV="$HOME/.ssh/environment"
        SSH_AGENT=`which ssh-agent`

        if [ -x "$SSH_AGENT" ]; then
            # source SSH settings, if applicable
            if [ -f "${SSH_ENV}" ]; then
                source "${SSH_ENV}" > /dev/null
                ps -x | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || { really_start_ssh_agent; }
            else
                really_start_ssh_agent;
            fi
        fi
    fi
    $SSH_ADD
fi

export GPG_TTY=$(tty)

SCREEN_PATH=$(which screen)
TMUX_PATH=$(which tmux)

if [ "$SHOWED_MUX_MESSAGE" != "true" ]; then
    if [ -x $SCREEN_PATH ]; then
        detached_screens=`screen -list | grep Detached`
        if [ ! -z "$detached_screens" ]; then
            echo "The following screens sessions are available:"
            echo -e "$detached_screens\n"
        fi
    fi
    if [ -x $TMUX_PATH ]; then
        detached_tmux=`tmux ls 2> /dev/null`
        if [ ! -z "$detached_tmux" ]; then
            echo "The following tmux sessions are available:"
            echo -e "$detached_tmux\n"
        fi
    fi
    export SHOWED_MUX_MESSAGE="true"
fi

if [ -e $HOME/bin/chruby.sh ]; then
    source $HOME/bin/chruby.sh
    #source /usr/local/share/chruby/auto.sh
    chruby 2.4.1
fi
