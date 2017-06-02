
green='\[\e[0;32m\]'     # Green
white='\[\e[0;37m\]'     # White
yellow='\[\e[0;33m\]'    # Yellow
red='\[\e[0;31m\]'       # Red
cyan='\[\e[0;36m\]'      # Cyan
reset='\[\e[m\]'

PS1="${green}(${white}\A${green})[${yellow}\u${green}@${cyan}\h${green}]${red} ${errcode}${white}\w\n${reset}$ "

alias ll='ls -l'
alias la='ls -A'
alias lh='ls -lh'
alias l='ls -CF'
alias wget="wget --timeout 10 -c"
# maths in the CLI
calc(){ echo "scale=2;$@" | bc;}

if [ -e /usr/local/share/chruby/chruby.sh ]; then
    source /usr/local/share/chruby/chruby.sh
    source /usr/local/share/chruby/auto.sh
fi

# check if another agent is running
if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
    echo "Starting gpg-agent"
    gpg-agent --quiet --daemon
fi
export GPG_TTY=$(tty)

# Completion
set -A complete_ssh_1 -- $(awk '{split($1,a,","); print a[1]}' ~/.ssh/known_hosts)
set -A complete_mosh_1 -- $(awk '{split($1,a,","); print a[1]}' ~/.ssh/known_hosts)
set -A complete_kill_1 -- -9 -HUP -INFO -KILL -TERM
PKG_LIST=$(ls -1 /var/db/pkg)
set -A complete_pkg_delete -- $PKG_LIST
set -A complete_pkg_info -- $PKG_LIST
set -A complete_rcctl_1 -- disable enable get ls order set
set -A complete_rcctl_2 -- $(ls /etc/rc.d)
set -A complete_gpg2 -- --refresh --receive-keys --armor --clearsign --sign --list-key --decrypt --verify --detach-sig
set -A complete_git -- pull push mpull mpush clone checkout status
pgrep -q mpd
if [ $? = 0 ]; then
    set -A complete_mpc -- ls play pause toggle prev random shuffle stop update
    set -A complete_mpc_2 -- $(mpc lsplaylists | sort)
fi
if [ -d "$HOME/.password-store" ]; then
    PASS_LIST=$(find "$HOME/.password-store" -type f -name \*.gpg | sed 's/^.*\.password-store\///' | sed 's/\.gpg$//g')
    set -A complete_pass -- $PASS_LIST -c generate edit insert git
    set -A complete_pass_2 -- $PASS_LIST push

fi
