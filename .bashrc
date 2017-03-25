# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#
# bash environment
#

# get platform type
case "$OSTYPE" in
    linux*)
        platform="linux"
        ;;
    openbsd*)
        platform="bsd"
        ;;
    *)
        platform="unknown"
        ;;
esac
export $platform

# a mix of BSD and Linux
PATH=$HOME/bin:/bin:/sbin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/usr/X11R6/bin:/usr/games:.
export PATH

export VISUAL=vim
export EDITOR=$VISUAL
export PAGER=less
export BROWSER=firefox
export GIT_EDITOR=vim
export INPUTRC=~/.inputrc
export GZIP=-9
export GREP_OPTIONS='-d skip'
export HISTCONTROL="ignorespace:ignoredups:erasedups"
export HISTIGNORE="&:ls:la:cd:exit:clear:fg"
export HISTTIMEFORMAT="[%Y-%m-%d - %H:%M:%S] "
shopt -s histappend
PROMPT_COMMAND='history -a'

if [ "${platform}" == "linux" ]; then
    export LANG='en_AU.UTF-8'
    export LC_ALL='en_AU.UTF-8'
    export LC_COLLATE='posix'
    export LC_CTYPE='en_AU.UTF-8'
else
    export LC_CTYPE='en_US.UTF-8'
    export PKG_PATH=http://mirror.internode.on.net/pub/OpenBSD/snapshots/packages/amd64
fi

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# correct cd misspellings
shopt -s cdspell

shopt -s extglob

# disable start/stop signals
stty -ixon

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

if [ ${TERM} == "xterm" ]; then
    export LESS_TERMCAP_mb=$'\E[01;31m'      # begin blinking
    export LESS_TERMCAP_md=$'\E[01;38;5;74m' # bold in blue
    export LESS_TERMCAP_me=$'\E[0m'          # end mode
    export LESS_TERMCAP_se=$'\E[0m'          # end standout-mode
    export LESS_TERMCAP_so=$'\E[38;5;246m'   # begin standout-mode - info box
    export LESS_TERMCAP_ue=$'\E[0m'          # end underline
    export LESS_TERMCAP_us=$'\E[04;33;146m'  # begin underline is now yellow
fi

if [ "${platform}" == 'linux' ]; then
    # 'ls' colors
    eval $(dircolors -b ~/.dircolors)
fi

#
# Alias definitions.
#

# enable color support of ls
if [ "${platform}" == 'linux' ]; then
    alias ls="ls --color=auto"
    alias rm="rm -v"
    alias mv="mv -v --backup=existing"
    alias cp="cp -v"
    alias grep="grep --color=auto"
    alias pac="sudo packer"
fi

alias ll='ls -l'
alias la='ls -A'
alias lh='ls -lh'
alias l='ls -CF'
alias h='history |grep'
alias wget="wget --timeout 10 -c"
alias tt="timetrackr"
# for debian quilt
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"
alias vlc1="vlc --play-and-exit"
# maths in the CLI
calc(){ echo "scale=2;$@" | bc;}

getpass() {
    gpg --quiet --no-tty --decrypt $HOME/Documents/passwords.gpg |grep "^$1" |awk '{print $2}' |tr -d '\n' |xclip -i
}


#
# completion
#
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    source /etc/bash_completion
fi
if [ -f /usr/local/share/bash-completion/bash_completion.sh ]; then
    source /usr/local/share/bash-completion/bash_completion.sh
fi

complete -cf sudo
complete -cf gksu

#
# colour definitions.
#
black='\[\e[0;30m\]'     # Black - Regular
red='\[\e[0;31m\]'       # Red
green='\[\e[0;32m\]'     # Green
yellow='\[\e[0;33m\]'    # Yellow
blue='\[\e[0;34m\]'      # Blue
purple='\[\e[0;35m\]'    # Purple
cyan='\[\e[0;36m\]'      # Cyan
white='\[\e[0;37m\]'     # White
black_b='\[\e[1;30m\]'   # Black - Bold
red_b='\[\e[1;31m\]'     # Red
green_b='\[\e[1;32m\]'   # Green
yellow_b='\[\e[1;33m\]'  # Yellow
blue_b='\[\e[1;34m\]'    # Blue
purple_b='\[\e[1;35m\]'  # Purple
cyan_b='\[\e[1;36m\]'    # Cyan
white_b='\[\e[1;37m\]'   # White
black_ul='\[\e[4;30m\]'  # Black - Underline
red_ul='\[\e[4;31m\]'    # Red
green_ul='\[\e[4;32m\]'  # Green
yellow_ul='\[\e[4;33m\]' # Yellow
blue_ul='\[\e[4;34m\]'   # Blue
purple_ul='\[\e[4;35m\]' # Purple
cyan_ul='\[\e[4;36m\]'   # Cyan
white_ul='\[\e[4;37m\]'  # White
black_bg='\[\e[40m\]'    # Black - Background
red_bg='\[\e[41m\]'      # Red
green_bg='\[\e[42m\]'    # Green
yellow_bg='\[\e[43m\]'   # Yellow
blue_bg='\[\e[44m\]'     # Blue
purple_bg='\[\e[45m\]'   # Purple
cyan_bg='\[\e[46m\]'     # Cyan
white_bg='\[\e[47m\]'    # White
reset='\[\e[m\]'

# set the prompt

parse_git_dirty () {
    [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "!"
}
parse_git_branch () {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/[\1$(parse_git_dirty)]/"
}

parse_hg_dirty () {
    [[ $( hg status 2> /dev/null ) != "" ]] && echo "!"
}
parse_hg_branch () {
    hg branch 2> /dev/null | sed -e "s/\(.*\)/[\1$(parse_hg_dirty)]/"
}

prompt_command () {
    # set an error string for the prompt, if applicable
    local errcode="\$(printf '%.*s%.*s' $? $? $? ' ')"
    # are we root?
    local u_colour="${yellow}"
    [ "$EUID" == 0 ] && u_colour="${red}"
    # are we remote?
    local h_colour="${green}"
    [ -n "${SSH_CLIENT}" ] && h_colour="${red}"
    export PS1="${green}(${white}\A${green})[${u_colour}\u${green}@${h_colour}\h${green}]${red} ${errcode}${white}\w\n${green}$(parse_git_branch)$(parse_hg_branch)${reset}$ "
}
PROMPT_COMMAND=prompt_command


#
# start agents
#

SSH_ENV="$HOME/.ssh/environment"
GPG_AGENT=`which gpg-agent`
SSH_AGENT=`which ssh-agent`
SSH_ADD=`which ssh-add`

function start_ssh_agent
{
    echo "Initializing new SSH agent..."
    $SSH_AGENT | sed 's/^echo/#echo/' > "${SSH_ENV}"
    echo succeeded
    chmod 600 "${SSH_ENV}"
    source "${SSH_ENV}" > /dev/null
    $SSH_ADD;
}

if [ -x "$SSH_AGENT" ]; then
    # source SSH settings, if applicable
    if [ -f "${SSH_ENV}" ]; then
        source "${SSH_ENV}" > /dev/null
        ps -x | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || { start_ssh_agent; }
    else
        start_ssh_agent;
    fi
fi

if [ -x "$GPG_AGENT" ]; then
    # does `~/.gpg-agent-info' exist and point to a gpg-agent process accepting signals?
    if test -f $HOME/.gpg-agent-info && kill -0 `cut -d: -f 2 $HOME/.gpg-agent-info` 2>/dev/null; then
        GPG_AGENT_INFO=`cat $HOME/.gpg-agent-info | cut -c 16-`
    else
        # gpg-agent not available, start it
        eval `$GPG_AGENT --daemon --no-grab --write-env-file`
    fi
    export GPG_TTY=$(tty)
    export GPG_AGENT_INFO
fi

#
# screen Login greeting
#
if [ "$SHOWED_SCREEN_MESSAGE" != "true" ]; then
    if [ -x /usr/bin/screen ]; then
        detached_screens=`screen -list | grep Detached`
        if [ ! -z "$detached_screens" ]; then
            echo "The following screens sessions are available:"
            echo -e "$detached_screens\n"
        fi
    fi
    if [ -x /usr/bin/tmux ]; then
        detached_tmux=`tmux ls 2> /dev/null`
        if [ ! -z "$detached_tmux" ]; then
            echo "The following tmux sessions are available:"
            echo -e "$detached_tmux\n"
        fi
    fi
    export SHOWED_SCREEN_MESSAGE="true"
fi

#
# other environment variables
#

source /usr/local/share/chruby/chruby.sh
source /usr/local/share/chruby/auto.sh
chruby ruby-2.0.0
