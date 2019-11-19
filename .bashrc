# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export HISTCONTROL="ignorespace:ignoredups:erasedups"
export HISTIGNORE="&:ls:la:cd:exit:clear:fg"
export HISTTIMEFORMAT="[%Y-%m-%d - %H:%M:%S] "
shopt -s histappend
PROMPT_COMMAND='history -a'

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

# completion
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

if [ -e $HOME/bin/common.sh ]; then
    source $HOME/bin/common.sh
fi
eval $( perl -Mlocal::lib )
