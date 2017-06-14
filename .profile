
#export JAVA_HOME="/usr/lib/jvm/openjdk"
#export JAVA_HOME="/usr/lib/jvm/jdk1.8.0_101"
export JAVA_HOME="/usr/local/openjdk8"
#export JAVA_HOME="/usr/local/openjdk7"
#export PATH="$HOME/.yarn/bin:$PATH"
[ -d "${HOME}/.node/bin" ] && PATH=${HOME}/.node/bin:$PATH
[ -d "${HOME}/.cabal/bin" ] && PATH=${HOME}/.cabal/bin:$PATH
[ -d "${HOME}/bin" ] && PATH=${HOME}/bin:$PATH
export PATH
export GOPATH=$HOME
export XML_CATALOG_FILES="${HOME}/src/XMLCatalog/catalog.xml"
export LC_ALL=en_AU.UTF-8
export LC_CTYPE=en_AU.UTF-8
export VISUAL=vim
export EDITOR=$VISUAL
export PAGER=less
export BROWSER=firefox
export GIT_EDITOR=vim
#GZIP=-9
#GREP_OPTIONS='-d skip'
#export XDG_RUNTIME_DIR=/run/user/$(id -u)

if [ -n "$KSH_VERSION" ]; then
    export ENV=${HOME}/.kshrc
fi

# SSH agent startup
SSH_ENV="$HOME/.ssh/environment"
function start_agent {
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" >/dev/null
     /usr/bin/ssh-add
}
if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" >/dev/null
     pid=$(pgrep -U $(id -u) ssh-agent)
     [ "$pid" != "$SSH_AGENT_PID" ] && start_agent
else
     start_agent
fi

# GPG agent startup
if ! gpg-connect-agent --quiet /bye > /dev/null 2> /dev/null; then
    echo "Starting gpg-agent"
    gpg-agent --quiet --daemon
fi
export GPG_TTY=$(tty)

#umask 022
