

## Options

setopt NO_BEEP
setopt C_BASES
setopt OCTAL_ZEROES
setopt PRINT_EIGHT_BIT
setopt SH_NULLCMD
setopt AUTO_CONTINUE
setopt NO_BG_NICE
setopt PATH_DIRS
setopt NO_NOMATCH
setopt EXTENDED_GLOB
disable -p '^'

setopt LIST_PACKED
setopt BASH_AUTO_LIST
setopt NO_AUTO_MENU
setopt NO_CORRECT
setopt NO_ALWAYS_LAST_PROMPT
setopt NO_FLOW_CONTROL

setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS

setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY

HISTSIZE=9000
SAVEHIST=9000
HISTFILE=~/.history
bindkey "^R" history-incremental-search-backward
bindkey -v

autoload -U colors
colors

# title
chpwd () {print -Pn "\e]0;%n@%m: %~\a"}


## Prompt

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn hg
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'
precmd () { vcs_info }

setopt PROMPT_SUBST
autoload -U promptinit && promptinit
PS1='%{$fg[green]%}(%{$fg[white]%}%*%{$fg[green]%})[%(!.$fg[red].$fg[yellow])%n%{$fg[green]%}@%{$fg[green]%}%m%{$fg[green]%}]%(?.. $fg[red]%? )%{$fg[white]%}%~
%{$fg[green]%}${vcs_info_msg_0_}%{$reset_color%}%(!.#.$) '


## Completion

autoload -Uz compinit && compinit
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# colored completion - use my LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin \
                                           /usr/local/bin  \
                                           /usr/sbin       \
                                           /usr/bin        \
                                           /sbin           \
                                           /bin            \
                                           /usr/X11R6/bin
#setopt completealiases

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init () {
        printf '%s' "${terminfo[smkx]}"
    }
    function zle-line-finish () {
        printf '%s' "${terminfo[rmkx]}"
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

virtualenv_info() {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

if [ -z "$SSH_AUTH_SOCK" ] ; then
    echo "Starting ssh-agent"
    eval `ssh-agent -s`
    ssh-add
fi

# check if another agent is running
if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
    echo "Starting gpg-agent"
    gpg-agent --quiet --daemon
fi
export GPG_TTY=$(tty)


#
# screen Login greeting
#
if [ "$SHOWED_MUX_MESSAGE" != "true" ]; then
    if [ -x /usr/bin/screen ]; then
        detached_screens=`screen -list | grep Detached`
    fi
    if [ -x /usr/bin/tmux ]; then
        detached_tmux=`tmux ls 2> /dev/null`
    fi
    if [ -n "$detached_screens" -o -n "$detached_tmux" ]; then
        echo "The following sessions are available:"
        echo -e "$detached_tmux"
        echo -e "$detached_screens"
    fi
    export SHOWED_SCREEN_MESSAGE="true"
fi


## Aliases

alias ll='ls -l'
alias la='ls -A'
alias lh='ls -lh'
alias l='ls -CF'
alias wget="wget --timeout 10 -c"
# maths in the CLI
calc(){ echo "scale=2;$@" | bc;}

if [ -e $HOME/bin/chruby.sh ]; then
    source $HOME/bin/chruby.sh
    #source /usr/local/share/chruby/auto.sh
    chruby 2.4.1
fi
