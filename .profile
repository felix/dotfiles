
hostname=$(hostname |cut -d. -f1)
os=$(uname -s)

# Build my path
PATH=/sbin:/bin:/usr/sbin:/usr/bin

for bindir in $HOME/bin \
	$HOME/go/bin \
	$HOME/.local/bin \
	$HOME/.node/bin \
	$HOME/.cabal/bin \
	$HOME/.cargo/bin \
	$HOME/.yarn/bin \
	$HOME/perl5/bin \
	/opt/local/bin \
	$HOME/Library/Python/3.7/bin \
	$HOME/Library/Python/3.8/bin \
	/Library/TeX/texbin \
	/usr/local/opt/perl/bin \
	/usr/local/go/bin \
	/usr/local/bin \
	/usr/local/sbin \
	/sbin \
	/bin \
	/usr/sbin \
	/usr/bin ; do
		[ -d "$bindir" ] && PATH=$PATH:$bindir
done

# Should not need to export but just in case
export PATH

if [ -d "${HOME}/perl5/bin" ]; then
    export PERL5LIB="{$HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    export PERL_LOCAL_LIB_ROOT="${HOME}/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    export PERL_MB_OPT="--install_base \"${HOME}/perl5\""
    export PERL_MM_OPT="INSTALL_BASE=${HOME}/perl5"
fi

[ -d /opt/local/share/man ] && MANPATH=/opt/local/share/man:$MANPATH

if [ -z "$XDG_RUNTIME_DIR" ]; then
	export XDG_RUNTIME_DIR="/tmp/$USER-xdg-runtime"
	mkdir -p "$XDG_RUNTIME_DIR"
fi

#export GOPATH=$HOME
export SAVEHIST=9000
export LC_ALL=en_AU.UTF-8
export LC_CTYPE=en_AU.UTF-8
export EDITOR=nvim
export VISUAL=$EDITOR
#export TERMINAL=urxvtcd
export PAGER=less
export BROWSER=firefox
export GIT_EDITOR=$EDITOR
export XML_CATALOG_FILES="${HOME}/src/XMLCatalog/catalog.xml"
export PASSWORD_STORE_X_SELECTION=primary
export HISTSIZE=9000
export HISTFILE=~/.history
export CLICOLOR=true
[ -n "$KSH_VERSION" ] && export ENV=${HOME}/.kshrc

#umask 022
