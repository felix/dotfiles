
[ -f /etc/profile ] && . /etc/profile

# Build my path
[ -d $HOME/bin ] && PATH=$HOME/bin:$PATH
[ -d $HOME/go/bin ] && PATH=$HOME/go/bin:$PATH
[ -d /usr/local/plan9/bin ] && PATH=$PATH:/usr/local/plan9/bin
#export PATH

if [ -d "$HOME/perl5/bin" ]; then
    export PERL5LIB="{$HOME}/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
    export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
    export PERL_MB_OPT="--install_base \"$HOME/perl5\""
    export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"
fi

#export GOPATH=$HOME
export SAVEHIST=9000
export LC_ALL=en_AU.UTF-8
export LC_CTYPE=en_AU.UTF-8
export EDITOR=nvim
export VISUAL=$EDITOR
export PAGER=less
export GIT_EDITOR=$EDITOR
export XML_CATALOG_FILES="$HOME/src/XMLCatalog/catalog.xml"
export PASSWORD_STORE_X_SELECTION=primary
export HISTSIZE=9000
export HISTCONTROL=ignorespace:ignoredups
export HISTFILE=~/.history
export COLORTERM=true
export ENV=$HOME/.kshrc
#export MOZ_ENABLE_WAYLAND=1
export GOPRIVATE=github.com/toennjes,gitlab.com/toennjes,src.userspace.com.au
export GOTELEMETRY=off

#umask 022

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
