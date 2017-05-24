
#export JAVA_HOME="/usr/lib/jvm/openjdk"
#export JAVA_HOME="/usr/lib/jvm/jdk1.8.0_101"
export JAVA_HOME="/usr/local/openjdk8"
#export JAVA_HOME="/usr/local/openjdk7"
#export PATH="$HOME/.yarn/bin:$PATH"
[ -d "${HOME}/.node/bin" ] && PATH=${HOME}/.node/bin:$PATH
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

[ -z "$SSH_AUTH_SOCK" ] && eval `ssh-agent -s` && ssh-add

#umask 022
