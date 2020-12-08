# Load defaults
[ -e /etc/ksh.kshrc ] && . /etc/ksh.kshrc

red='\[\e[0;31m\]'
green='\[\e[0;32m\]'
yellow='\[\e[0;33m\]'
blue='\[\e[0;34m\]'
purple='\[\e[0;35m\]'
cyan='\[\e[0;36m\]'
white='\[\e[0;37m\]' # not really white
reset='\[\e[m\]'

__exit_status() {
	case $1 in
		0) return ;;
		*) printf '(%d) ' "$1" ;;
	esac
}

__branch_status() {
	ref="$(env git branch --show-current HEAD 2> /dev/null)"
	case $? in        # See what the exit code is.
		0) ;;           # contains the name of a checked-out branch.
		128) return ;;  # No Git repository here.
		# Otherwise, see if HEAD is in a detached state.
		*) ref="$(env git rev-parse --short HEAD 2> /dev/null)" || return ;;
	esac
	printf ' (%s)' "${ref#refs/heads/}"
	unset ref
}

set -o vi

PS1='${green}(${white}\A${green})[${yellow}\u${green}@${cyan}\h${green}]${purple}$(__branch_status $?)${red} ${errcode}${white}\w\n${red}$(__exit_status $?)${reset}\$ '
#PS1="${green}(${white}\A${green})[${yellow}\u${green}@${cyan}\h${green}]${red} ${errcode}${white}\w\n${reset}$ "

# Completions
# When we need to force tab completion
#bind ^i=complete
HOST_LIST=$(awk '{split($1,a,","); gsub("].*", "", a[1]); gsub("\\[", "", a[1]); print a[1] " root@" a[1]}' ~/.ssh/known_hosts | sort | uniq)
set -A complete_ssh -- $HOST_LIST
set -A complete_scp -- $HOST_LIST
set -A complete_mosh -- $HOST_LIST
set -A complete_ping -- $HOST_LIST
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
set -A complete_gpg2 -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_make_1 -- install clean build lint test
set -A complete_git_1 -- pull push mpull mpush clone checkout status commit clean config cherry-pick init add reset log show branch diff merge rebase tag fetch whatchanged remote
set -A complete_ifconfig_1 -- $(ifconfig | grep ^[a-z] | cut -d: -f1)
if [ -f /dev/mixer ]; then
	set -A complete_mixerctl_1 -- $(mixerctl | cut -d= -f 1)
fi

PASS_LIST=$(find $HOME/.password-store/ -type f | grep "gpg$" | \
	sed 's/^\.password-store\///' | \
	sed 's/\.gpg$//')

set -A complete_pass -- $PASS_LIST
if [ -n "$(command -v mpc)" ]; then
	set -A complete_mpc_1 -- \
		add clear clearerror consume current find findadd list listall ls lsplaylists \
		next pause pause-if-playing play playlist prev random repeat rescan \
		search searchadd searchplay shuffle single stats stop update volume
	set -A complete_mpc_2 -- $(mpc lsplaylists | sort)
fi

if [ -d "$HOME/.password-store" ]; then
	PASS_LIST=$(find "$HOME/.password-store" -type f -name \*.gpg | sed 's/^.*\.password-store\///' | sed 's/\.gpg$//g')
	set -A complete_pass -- $PASS_LIST -c generate edit insert git
	#set -A complete_pass_2 -- $PASS_LIST push
fi

. $HOME/bin/dirstack.ksh

[ -e $HOME/bin/common.sh ] && . $HOME/bin/common.sh
