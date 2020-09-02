
green='\[\e[0;32m\]'     # Green
white='\[\e[0;37m\]'     # White
yellow='\[\e[0;33m\]'    # Yellow
red='\[\e[0;31m\]'       # Red
cyan='\[\e[0;36m\]'      # Cyan
reset='\[\e[m\]'

PS1="${green}(${white}\A${green})[${yellow}\u${green}@${cyan}\h${green}]${red} ${errcode}${white}\w\n${reset}$ "

# Completion
set -A complete_ssh_1 -- $(awk '{split($1,a,","); print a[1]}' ~/.ssh/known_hosts)
set -A complete_mosh_1 -- $(awk '{split($1,a,","); print a[1]}' ~/.ssh/known_hosts)
set -A complete_kill_1 -- -9 -HUP -INFO -KILL -TERM
if [ -d /var/db/pkg ]; then
	PKG_LIST=$(ls -1 /var/db/pkg)
	set -A complete_pkg_delete -- $PKG_LIST
	set -A complete_pkg_info -- $PKG_LIST
fi
set -A complete_rcctl_1 -- disable enable get ls order set start stop restart
if [ -d /etc/rc.d ]; then
	set -A complete_rcctl_2 -- $(ls /etc/rc.d)
fi
set -A complete_gpg2 -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_git -- pull push mpull mpush clone checkout status log
set -A complete_dm_1 -- sync check add
# pgrep -q mpd
# if [ $? = 0 ]; then
#     set -A complete_mpc -- ls play pause toggle prev random shuffle stop update
#     set -A complete_mpc_2 -- $(mpc lsplaylists | sort)
# fi
if [ -d "$HOME/.password-store" ]; then
    PASS_LIST=$(find "$HOME/.password-store" -type f -name \*.gpg | sed 's/^.*\.password-store\///' | sed 's/\.gpg$//g')
    set -A complete_pass -- $PASS_LIST -c generate edit insert git
    #set -A complete_pass_2 -- $PASS_LIST push

fi

 if [ -e $HOME/bin/common.sh ]; then
     . $HOME/bin/common.sh
 fi
