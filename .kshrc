
green='\[\e[0;32m\]'     # Green
white='\[\e[0;37m\]'     # White
yellow='\[\e[0;33m\]'    # Yellow
red='\[\e[0;31m\]'       # Red
cyan='\[\e[0;36m\]'      # Cyan
reset='\[\e[m\]'

PS1="${green}(${white}\A${green})[${yellow}\u${green}@${cyan}\h${green}]${red} ${errcode}${white}\w\n${reset}$ "

# Completions
HOST_LIST=$(awk '{split($1,a,","); gsub("].*", "", a[1]); gsub("\\[", "", a[1]); print a[1] " root@" a[1]}' ~/.ssh/known_hosts | sort | uniq)
set -A complete_ssh -- $HOST_LIST
set -A complete_scp -- $HOST_LIST
set -A complete_mosh -- $HOST_LIST
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
    set -A complete_mpc -- ls play pause toggle prev random shuffle stop update
    set -A complete_mpc_2 -- $(mpc lsplaylists | sort)
fi
if [ -d "$HOME/.password-store" ]; then
    PASS_LIST=$(find "$HOME/.password-store" -type f -name \*.gpg | sed 's/^.*\.password-store\///' | sed 's/\.gpg$//g')
    set -A complete_pass -- $PASS_LIST -c generate edit insert git
    #set -A complete_pass_2 -- $PASS_LIST push

fi

 if [ -e $HOME/bin/common.sh ]; then
     . $HOME/bin/common.sh
 fi
