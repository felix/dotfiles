
hostname=$(hostname -s)

#export JAVA_HOME="/usr/lib/jvm/openjdk"
#export JAVA_HOME="/usr/lib/jvm/jdk1.8.0_101"
export JAVA_HOME="/usr/local/openjdk8"
#export JAVA_HOME="/usr/local/openjdk7"
#export PATH="$HOME/.yarn/bin:$PATH"
[ -d "${HOME}/.node/bin" ] && PATH=${HOME}/.node/bin:$PATH
[ -d "${HOME}/.cabal/bin" ] && PATH=${HOME}/.cabal/bin:$PATH
[ -d "${HOME}/bin" ] && PATH=${HOME}/bin:$PATH
if [ -d "${HOME}/perl5/bin" ]; then
    PATH=${HOME}/perl5/bin:$PATH
    export PERL5LIB="{$HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    export PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    export PERL_MB_OPT="--install_base \"${HOME}/perl5\""
    export PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"
fi
export PATH
export GOPATH=$HOME
export XML_CATALOG_FILES="${HOME}/src/XMLCatalog/catalog.xml"
export LC_ALL=en_AU.UTF-8
export LC_CTYPE=en_AU.UTF-8
export EDITOR=vim
export VISUAL=$EDITOR
export PAGER=less
export BROWSER=firefox
export GIT_EDITOR=$EDITOR
export PASSWORD_STORE_X_SELECTION=primary
export HISTSIZE=9000
export HISTFILE=~/.history
export CLICOLOR=true
export SAVEHIST=9000
export VIRTUALENV_PYTHON=$(which python3)
#export XDG_RUNTIME_DIR=/run/user/$(id -u)
[ "$XDG_CURRENT_DESKTOP" = "KDE" ] || [ "$XDG_CURRENT_DESKTOP" = "GNOME" ] || export QT_QPA_PLATFORMTHEME="qt5ct"

if [ -n "$KSH_VERSION" ]; then
    export ENV=${HOME}/.kshrc
fi

#umask 022
