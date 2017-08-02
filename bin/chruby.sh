RUBIES=$(find "$PREFIX"/opt/rubies "$HOME"/.rubies -mindepth 1 -maxdepth 1 -type d 2>/dev/null)

chruby_reset() {
    [ -z "$RUBY_ROOT" ] && return

    PATH=$(echo $PATH |sed -e "s@$RUBY_ROOT/bin:\?@@g")

    if (( $(id -u) != 0 )); then
        GEM_HOME=${GEM_HOME:-""}
        GEM_PATH=${GEM_PATH:-""}
        GEM_ROOT=${GEM_ROOT:-""}
        PATH=$(echo $PATH |sed -e "s@$GEM_HOME/bin:\?@@g" -e "s@$GEM_ROOT/bin:\?@@g" -e 's/:\+/:/g' -e 's/^://g' -e 's/:$//g')
        GEM_PATH=$(echo $GEM_PATH |sed -e "s@$GEM_ROOT:\?@@g" -e "s@$GEM_HOME:\?@@g" -e 's/:\+/:/g' -e 's/^://g' -e 's/:$//g')
        unset GEM_ROOT GEM_HOME GEM_PATH
    fi

    unset RUBY_ROOT RUBY_ENGINE RUBY_VERSION RUBYOPT
    hash -r
}

chruby_use() {
    if [ ! -x "$1/bin/ruby" ]; then
        echo "chruby: $1/bin/ruby not executable" >&2
        return 1
    fi

    [ -n "$RUBY_ROOT" ] && chruby_reset

    export RUBY_ROOT="$1"
    export RUBYOPT="$2"
    export PATH="$RUBY_ROOT/bin:$PATH"

    eval "$("$RUBY_ROOT/bin/ruby" - <<EOF
    puts "export RUBY_ENGINE=#{defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'ruby'};"
    puts "export RUBY_VERSION=#{RUBY_VERSION};"
    begin; require 'rubygems'; puts "export GEM_ROOT=#{Gem.default_dir.inspect};"; rescue LoadError; end
EOF
)"

    if (( $(id -u) != 0 )); then
        export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
        export GEM_PATH="$GEM_HOME${GEM_ROOT:+:$GEM_ROOT}${GEM_PATH:+:$GEM_PATH}"
        export PATH="$GEM_HOME/bin${GEM_ROOT:+:$GEM_ROOT/bin}:$PATH"
    fi
}

chruby_auto() {
    local dir="$PWD/" version

    until [ -z "$dir" ]; do
        dir="${dir%/*}"

        if { read -r version <"$dir/.ruby-version"; } 2>/dev/null || [ -n "$version" ]; then
            if [ "$version" = "$RUBY_VERSION" ]; then return
            else
                chruby "$version"
                return $?
            fi
        fi
    done

    if [ -n "$RUBY_VERSION" ]; then
        chruby_reset
    fi
}

chruby() {
    case "$1" in
        -h|--help)
            echo "usage: chruby [RUBY|VERSION|system] [RUBYOPT...]"
            ;;
        "")
            local dir star
            for dir in "${RUBIES[@]}"; do
                dir="${dir%%/}"
                star=" "
                [ "$dir" = "$RUBY_ROOT" ] && star="*"

                echo " $star ${dir##*/}"
            done
            ;;
        system)
            chruby_reset
            ;;
        *)
            local dir match
            for dir in "${RUBIES[@]}"; do
                dir="${dir%%/}"
                case "${dir##*/}" in
                    "$1")   match="$dir" && break ;;
                    *"$1"*) match="$dir" ;;
                esac
            done

            if [ -z "$match" ]; then
                echo "chruby: unknown Ruby: $1" >&2
                return 1
            fi

            shift
            chruby_use "$match" "$*"
            ;;
    esac
}
