#!/bin/sh

# Export files in M3U file to directory tree, recoding as necessary

# Author: Felix Hanley <felix@userspace.com.au>

dirname=$(which dirname)
[ -z $dirname ] && echo "Missing dirname, cannot continue."
readlink=$(which readlink)
[ -z $readlink ] && echo "Missing readlink, cannot continue."
flac=$(which flac)
[ -z $flac ] && echo "Missing flac, cannot continue."
oggenc=$(which oggenc)
[ -z $oggenc ] && echo "Missing oggenc, cannot continue."
lame=$(which lame)
[ -z $lame ] && echo "Missing lame, cannot continue."

usage() {
    echo "Export files in an M3U playlist\n"
    echo "usage: $0 [options] <m3u file> <source base> [output path]"
    echo "\nOptions:"
    echo "\t-v\tBe verbose"
    echo "\t-q\tQuality (0-10)"
    echo "\t-f\tForce overwriting existing files"
    echo "\t-r\tM3U has relative paths"
    echo "\t-l\tCreate symlink instead of copying"
    echo "\t-t\tOutput type ogg (default), mp3, flac"
    echo "\t-n\tDry run, don't actually do anything"
    echo "\t-h\tThis help"
    exit 1
}

flac2ogg() {
    local src=$1; shift
    local dst=$1; shift
    local cmd="$oggenc --quiet --utf8 -q $QUALITY -o $dst $src"
    [ -n "$VERBOSE" ] && echo "Running $cmd"
    [ -z "$DRYRUN" ] && $cmd
}

copy() {
    local src=$1; shift
    local dst=$1; shift
    if [ -n "$LINK" ]; then
        [ -n "$VERBOSE" ] && echo "Copying $src"
        create_link $src $dst
    else
        [ -n "$VERBOSE" ] && echo "Linking $src"
        [ -z "$DRYRUN" ] && cp $src $dst
    fi
}

mp32ogg() {
    local src=$1; shift
    local dst=$1; shift
    # TODO
}

ensure_path() {
    local directory=$($dirname $1)
    if [ ! -d $directory ]; then
        [ -n "$VERBOSE" ] && printf "Creating path %s\n" $directory
        [ -z "$DRYRUN" ] && mkdir -p $($dirname $1) > /dev/null
    fi
}

create_link() {
    local src=$1; shift;
    local dst=$1; shift;

    if [ -h $src ]; then
        # The dotfile itself is a link, copy it
        src="$HOME/$($readlink -n "$src")"
    fi
    # Symbolic link command
    linkcmd="ln -s"
    if [ -n $FORCE]; then
        linkcmd="$linkcmd -f"
    fi
    [ -z "$DRYRUN" ] && $linkcmd "$src" "$dst"
}

scan() {
    local count=0
    local intype infile outfile

    local total=$(wc -l <$M3U)

    while read infile; do
        count=$((count+1))
        if [ -n "$VERBOSE" ]; then
            echo "File $count: $infile"
        else
            printf "%d/%d\r" $count $total
        fi

        intype=${infile##*.}

        [ -n "$RELATIVE" ] && infile="$INBASE/$infile"
        outfile="${infile%.*}.$TYPE"
        outfile=$OUTBASE/${outfile#${INBASE}/}

        if [ ! -f "$infile" ]; then
            echo "Missing file: $infile"
            continue
        fi

        [ -f "$outfile" ] && continue

        ensure_path $outfile
        if [ "$intype" = "$TYPE" ]; then
            copy "$infile" "$outfile"
        else
            "${intype}2${TYPE}" "$infile" "$outfile"
        fi
    done < $M3U
    echo "Processed $count lines"
}

main() {
    while getopts ":vflnrq:t:" opt; do
        case $opt in
            f) FORCE=true
                ;;
            n) DRYRUN=true
                ;;
            v) VERBOSE=true
                ;;
            l) LINK=true
                ;;
            q) QUALITY=$OPTARG
                ;;
            t) TYPE=$OPTARG
                ;;
            r) RELATIVE=true
                ;;
            ?) usage
                ;;
        esac
    done

    # Shift the rest
    shift $(($OPTIND - 1))

    M3U=$1; shift
    INBASE=$(readlink -f $1); shift
    OUTBASE=$(readlink -f ${1:-"./"})
    QUALITY=${QUALITY:-7}
    TYPE=${TYPE:-ogg}

    if [ -z "$M3U" ]; then
        echo "Missing M3U file"
        usage
        exit 1
    fi

    scan
}

main "$@"
