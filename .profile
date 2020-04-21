
hostname=$(hostname |cut -d. -f1)
os=$(uname -s)

# Build my path
PATH=/sbin:/bin:/usr/sbin:/usr/bin

prefix="/usr"
if [ "$os" = "FreeBSD" ] || [ "$os" = "Darwin" ]; then
    prefix="/usr/local"
fi

[ -d "/usr/local/bin" ] && PATH=/usr/local/bin:$PATH
[ -d "/usr/local/sbin" ] && PATH=/usr/local/sbin:$PATH
[ -d "${HOME}/.node/bin" ] && PATH=${HOME}/.node/bin:$PATH
[ -d "${HOME}/.cabal/bin" ] && PATH=${HOME}/.cabal/bin:$PATH
[ -d "${HOME}/.cargo/bin" ] && PATH=${HOME}/.cargo/bin:$PATH
[ -d "${HOME}/.yarn/bin" ] && PATH=${HOME}/.yarn/bin:$PATH
[ -d "/usr/local/opt/perl/bin" ] && PATH=$PATH:/usr/local/opt/perl/bin
[ -d "/usr/local/go/bin" ] && PATH=$PATH:/usr/local/go/bin
[ -d "${HOME}/go/bin" ] && PATH=${HOME}/go/bin:$PATH
[ -d "${HOME}/bin" ] && PATH=${HOME}/bin:$PATH
if [ -d "${HOME}/perl5/bin" ]; then
    PATH=${HOME}/perl5/bin:$PATH
    export PERL5LIB="{$HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    export PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    export PERL_MB_OPT="--install_base \"${HOME}/perl5\""
    export PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"
fi
[ -d "${HOME}/.local/bin" ] && PATH=${HOME}/.local/bin:$PATH
#[ -d "/usr/local/go/bin" ] && PATH=/usr/local/go/bin:$PATH
[ -d "${HOME}/bin" ] && PATH=${HOME}/bin:$PATH
# if [ -d "${HOME}/src/github.com/9fans/plan9port" ]; then
#     export PLAN9=$HOME/src/github.com/9fans/plan9port
#     PATH=$PATH:$PLAN9/bin
# fi

if [ "$os" = "Darwin" ]; then
	[ -d "/opt/local/bin" ] && PATH=/opt/local/bin:/opt/local/sbin:$PATH
	[ -d "$HOME/Library/Python/3.7/bin" ] && PATH=$HOME/Library/Python/3.7/bin:$PATH
	MANPATH=/opt/local/share/man:${MANPATH}
	[ -d "/Library/TeX/texbin" ] && PATH=$PATH:/Library/TeX/texbin
fi

export PATH

#export GOPATH=$HOME
export SAVEHIST=9000
export LC_ALL=en_AU.UTF-8
export LC_CTYPE=en_AU.UTF-8
export EDITOR=nvim
export VISUAL=$EDITOR
export TERMINAL=urxvtcd
export PAGER=less
export BROWSER=firefox
#export VIRTUALENV_PYTHON=$prefix/bin/python3
export GIT_EDITOR=$EDITOR
export XML_CATALOG_FILES="${HOME}/src/XMLCatalog/catalog.xml"
export PASSWORD_STORE_X_SELECTION=primary
export JAVA_HOME="${JAVA_HOME:-$prefix/openjdk8}"
[ "$os" = "Darwin" ] && export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-12.0.1.jdk/Contents/Home"
export HISTSIZE=9000
export HISTFILE=~/.history
export CLICOLOR=true
[ -n "$KSH_VERSION" ] && export ENV=${HOME}/.kshrc
#export WORKON_HOME=$HOME/.venv

#umask 022
