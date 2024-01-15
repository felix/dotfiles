# Load defaults
[ -e /etc/ksh.kshrc ] && . /etc/ksh.kshrc

__exit_status() {
	case $1 in
		0) return ;;
		*) printf '(%d) ' "$1" ;;
	esac
}

__branch_status() {
	ref="$(env git branch --show-current HEAD 2>/dev/null)"
	case $? in        # See what the exit code is.
		0) ;;           # contains the name of a checked-out branch.
		128) return ;;  # No Git repository here.
		# Otherwise, see if HEAD is in a detached state.
		*) ref="$(env git rev-parse --short HEAD 2>/dev/null)" || return ;;
	esac
	printf ' (%s)' "${ref#refs/heads/}"
	unset ref
}

set -o vi

red='\[\e[0;31m\]'
green='\[\e[0;32m\]'
yellow='\[\e[0;33m\]'
#blue='\[\e[0;34m\]'
purple='\[\e[0;35m\]'
cyan='\[\e[0;36m\]'
grey='\[\e[0;37m\]'
white='\[\e[97m\]'
reset='\[\e[0;0m\]'

PS1='${grey}\A ${yellow}\u${green}@${cyan}\h${purple}$(__branch_status $?) ${grey}\w\n${red}$(__exit_status $?)${reset}\$ '
#PS1='\A \u@\h$(__branch_status $?) \w\n$(__exit_status $?)\$ '

# Completions
# When we need to force tab completion
#bind ^i=complete
HOST_LIST=$(awk '{split($1,a,","); gsub("].*", "", a[1]); gsub("\\[", "", a[1]); print a[1] " root@" a[1]}' ~/.ssh/known_hosts | sort | uniq)
set -A complete_ssh -- ${HOST_LIST[*]}
set -A complete_scp -- $HOST_LIST
set -A complete_mosh -- $HOST_LIST
set -A complete_ping -- $HOST_LIST
set -A complete_drill -- $HOST_LIST
set -A complete_kill_1 -- -9 -HUP -INFO -KILL -TERM
if [ -d /var/db/pkg ]; then
	PKG_LIST=$(ls -1 /var/db/pkg)
	set -A complete_pkg_delete -- $PKG_LIST
	set -A complete_pkg_info -- $PKG_LIST
fi
if [ -d /etc/rc.d ]; then
	set -A complete_rcctl_1 -- disable enable get ls order set start stop restart
	set -A complete_rcctl_2 -- $(ls /etc/rc.d)
fi
if [ -n "$(command -v iconfig)" ]; then
set -A complete_ifconfig_1 -- $(ifconfig | grep '^[a-z]' | cut -d: -f1)
fi
set -A complete_chown_1 -- $(users)
set -A complete_gpg2 -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_make_1 -- install clean build lint test
set -A complete_git_1 -- \
	$(git --list-cmds=main) \
	$(git config --get-regexp ^alias\. | awk -F '[. ]' '{ print $2 }')
if [ -f /dev/mixer ]; then
	set -A complete_mixerctl_1 -- $(mixerctl | cut -d= -f 1)
fi

if [ -n "$(command -v mpc)" ]; then
	set -A complete_mpc_1 -- \
		add clear clearerror consume current find findadd list listall ls lsplaylists \
		next pause pause-if-playing play playlist prev random repeat rescan \
		search searchadd searchplay shuffle single stats stop update volume
	set -A complete_mpc_2 -- $(mpc lsplaylists 2>/dev/null | sort)
fi

if [ -n "$(command -v pass)" ]; then
	PASS_LIST=$(find "$HOME/.password-store" -type f -name '*.gpg' | sed 's/^.*\.password-store\///' | sed 's/\.gpg$//g')
	set -A complete_pass_1 -- $PASS_LIST generate edit insert git otp
	set -A complete_pass_2 -- $PASS_LIST push pull
fi

. $HOME/bin/dirstack.ksh

alias ls='ls --color=auto'
alias ll='ls -l'
alias la='ls -A'
alias lh='ls -lh'
alias l='ls -CF'
alias h='history |grep'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias k='kubectl'
alias wget="wget --timeout 10 -c"
alias setclip="xclip -selection c"
alias getclip="xclip -selection c -o"
alias fsl="fossil"
if [ -n "$(command -v nvim)" ]; then
	alias vim="nvim"
	alias vimdiff="nvim -d"
fi
# alias vimf="vimfzf"
alias ap="ansible-playbook"
alias mutt-userspace='neomutt -F ~/.mutt/muttrc.userspace'
alias mutt-toennjes='neomutt -F ~/.mutt/muttrc.toennjes'
alias mutt-yelnah='neomutt -F ~/.mutt/muttrc.yelnah'
alias dockerm='docker-machine'
alias dockerc='docker-compose'
alias dcl='docker-compose logs -t -f --tail=100'

calc(){ printf 'scale=2;%s\n' "$*" |bc; }

if [ ! -S ~/.ssh/ssh_auth_sock ]; then
  eval `ssh-agent`
  ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
  ssh-add
fi
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock

GPG_TTY=$(tty)
export GPG_TTY

TMUX_PATH=$(command -v tmux)

if [ -x "$TMUX_PATH" ]; then
	if [ "$SHOWED_MUX_MESSAGE" != "true" ]; then
		detached_tmux=$(tmux ls 2> /dev/null)
		[ ! -z "$detached_tmux" ] && printf '\nDetached Tmux: %s\n' "$detached_tmux"
	fi
	export SHOWED_MUX_MESSAGE="true"
fi

if [ -z "${DISPLAY}" ] && [ "$(tty)" == "/dev/tty1" ]; then
	exec $HOME/bin/start-wm.sh
fi
