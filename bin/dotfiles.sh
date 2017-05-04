#!/usr/bin/env zsh

# Author: Felix Hanley <felix@userspace.com.au>

readlink=$(which readlink)
[[ -z $readlink ]] && echo "Missing readlink, cannot continue."
dirname=$(which dirname)
[[ -z $dirname ]] && echo "Missing dirname, cannot continue."
realpath=$(which realpath)
[[ -z $realpath ]] && echo "Missing realpath, cannot continue."

# show usage
#
usage() {
    echo -e "Manage your dotfiles"
    echo -e "\n$0 [-v] [-b] [-h] [-f] [-c] [dotfiles src]\n"
    echo -e "\t-f Force overwriting existing files"
    echo -e "\t-b Backup existing files"
    echo -e "\t-n Dry run, don't actually do anything"
    echo -e "\t-v Display output for each file tested"
    echo -e "\t-d Show diff if file exists"
    echo -e "\t-c Use colour"
    echo -e "\t-x Perform a cleanup afterwards"
    echo -e "\t-h This help\n"
    exit 1
}

output() {
    local reset='\e[0m'
    local white='\E[37;47m'
    local green='\E[32;47m'
    local red='\E[31;47m'
    local yellow='\E[33;47m'

    local output=$1; shift;
    local colour=${1-$white}; shift;
    [[ $COLOUR ]] && STATUS+=$colour
    [[ $COLOUR ]] && STATUS+=$reset
    STATUS+=$output
}

create_link() {
    local src=$1; shift;
    local dest=$1; shift;

    STATUS+=": linking"
    if [ -h $src ]; then
        # the dotfile itself is a link, copy it
        src="$HOME/$($readlink -n "$src")"
    fi
    [[ -z $DRYRUN ]] && ln -s -f "$src" "$dest"
}

remove_file() {
    local dest=$1; shift;
    STATUS+=": removing -> "
    [[ -z $DRYRUN ]] && rm -f "$dest"
}

copy_file() {
    local dest=$1; shift;
    if [[ $BACKUP ]]; then
        STATUS+=": copying -> "
        [[ -z $DRYRUN ]] && mv "$dest" "$dest.bak"
    fi
}

get_diff() {
    local src=$1; shift;
    local dest=$1; shift;

    local output="$(diff $dest $src)"
    if [[ -z $output ]]; then
        return 0
    else
        command -v colordiff >/dev/null
        [[ $? -ne 0 ]] && diff=diff || diff=colordiff
        echo -e "\ndiff $src $dest:\n"
        [[ $DIFF ]] && $diff $dest $src
        echo
        return 1
    fi
}

realpath() {
    canonicalize_path "$(resolve_symlinks "$1")"
}

resolve_symlinks() {
    local dir_context path
    path=$($readlink -- "$1")
    if [ $? -eq 0 ]; then
        dir_context=$($dirname -- "$1")
        resolve_symlinks "$(_prepend_path_if_relative "$dir_context" "$path")"
    else
        printf '%s\n' "$1"
    fi
}

_prepend_path_if_relative() {
    case "$2" in
        /* ) printf '%s\n' "$2" ;;
         * ) printf '%s\n' "$1/$2" ;;
    esac
}

canonicalize_path() {
    if [ -d "$1" ]; then
        _canonicalize_dir_path "$1"
    else
        _canonicalize_file_path "$1"
    fi
}

_canonicalize_dir_path() {
    (cd "$1" 2>/dev/null && pwd -P)
}

_canonicalize_file_path() {
    local dir file
    dir=$($dirname -- "$1")
    file=$(basename -- "$1")
    (cd "$dir" 2>/dev/null && printf '%s/%s\n' "$(pwd -P)" "$file")
}

# updates a link from the dotfiles src
# to the home directory
# $1 the file within the dotfile directory
#
scan() {
    local file=$1; shift;

    [[ $file == '.' || $file == '..' || $file =~ ~$ ]] && return 0
    local relative=${file#${DOTFILES}/}
    local dest=$HOME/$relative
    local src=$DOTFILES/$relative

    STATUS="$relative "

    # there are only 3 cases:
    # missing -> link
    # symlink -> relink
    # file -> clear and link (if forced)
    #
    if [ -e "$dest" ]; then
        # show diff?
        if [[ $DIFF || $FORCE ]]; then
            get_diff $src $dest
            local different=$(get_diff $src $dest)
        fi

        # not forced
        if [[ -z $FORCE ]]; then
            STATUS+=": exists, skipping"
            return 0
        fi

        # take a backup if not identical
        if [[ -n $different ]]; then
            copy_file $dest
        fi

        if [ -h "$dest" ]; then
            # symlink

            local destlink=$($readlink -n "$dest")
            if [ -h $src ]; then
                # if src is also a link, don't dereference it
                local srclink=$HOME/$($readlink -n "$src")
            else
                local destlink=$($realpath "$destlink")
                local srclink="$src"
            fi
            if [ "$destlink" == "$srclink" ]; then
                $STATUS+="-> identical"
                return 0
            fi
            # continue

        elif [ -f "$dest" ]; then
            # regular file
            # continue
            :

        else
            # unknown file?!?
            STATUS+=": unknown!!"
            return 1
        fi
        remove_file $dest

    else
        # missing, create path maybe
        local directory=$($dirname $dest)
        [[ -z $DRYRUN ]] && [ ! -d $directory ] && mkdir -p $($dirname $dest) > /dev/null
        STATUS+=": missing -> "
        # continue
    fi

    create_link $src $dest
    return 1
}

# cleanup the home folder
#
cleanup() {
    pushd $DOTFILES >/dev/null
    # each directory in dotfiles
    for directory in `find . \( -name .git -o -name .hg \) -prune -o -type d -print`; do
        if [[ $directory != '.' && $directory != '..' ]]; then
            local dir=$($realpath "$HOME/$directory")
            # note depth and confirmation!
            [[ -z $DRYRUN ]] && find $dir -maxdepth 1 -type l -xtype l -ok rm '{}' \;
        fi
    done
    popd >/dev/null
}

main() {

    # we are looking for DOT files!
    setopt  globdots

    while getopts ":fdbvcxn" opt; do
        case $opt in
            f) FORCE=true
                ;;
            b) BACKUP=true
                ;;
            n) DRYRUN=true
                ;;
            v) VERBOSE=true
                ;;
            d) DIFF=true
                ;;
            c) COLOUR=true
                ;;
            x) CLEANUP=true
                ;;
            ?) usage
                ;;
        esac
    done

    # shift the rest
    shift $(($OPTIND - 1))

    # default dotfiles path
    declare DOTFILES=$1
    if [ -z $DOTFILES ]; then
        DOTFILES=$HOME/src/dotfiles
    fi
    DOTFILES=$($realpath "${DOTFILES%/}")

    # collect output
    declare STATUS=""

    # each file and link in dotfiles, excluding VCS
    local find_opts="! -path '*.git*' -path '*.hg*')"
    for file in `find $DOTFILES \( -name .git -o -name .hg \) -prune -o \( -type f -print \) -o \( -type l -print \)`; do
        scan $file
        [[ $? -ne 0 || $VERBOSE ]] && echo $STATUS
    done

    if [[ $CLEANUP ]]; then
        cleanup
    fi
}

main "$@"
