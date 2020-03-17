#!/bin/sh

# Export files in M3U file to directory tree, recoding as necessary

# Author: Felix Hanley <felix@userspace.com.au>

dirname=$(command -v dirname)
[ -z $dirname ] && echo "Missing dirname, cannot continue." && exit 1
readlink=$(command -v readlink)
[ -z "$readlink" ] && echo "Missing readlink, cannot continue." && exit 1
realpath=$(command -v realpath)
if [ -z "$realpath" ]; then
	# Provide a realpath implementation
	realpath() {
		canonicalize_path "$(resolve_symlinks "$1")"
	}
fi
flac=$(command -v flac)
[ -z $flac ] && echo "Missing flac, cannot continue."
oggenc=$(command -v oggenc)
[ -z $oggenc ] && echo "Missing oggenc, cannot continue."
lame=$(command -v lame)
[ -z $lame ] && echo "Missing lame, cannot continue."
ffmpeg=$(command -v ffmpeg)
[ -z $ffmpeg ] && echo "Missing ffmpeg, cannot continue."

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

resolve_symlinks() {
	if path=$($readlink -- "$1"); then
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
		# Canonicalize dir path
		(cd "$1" 2>/dev/null && pwd -P)
	else
		# Canonicalize file path
		dir=$("$dirname" -- "$1")
		file=$(basename -- "$1")
		(cd "$dir" 2>/dev/null && printf '%s/%s\n' "$(pwd -P)" "$file")
	fi
}

flac2ogg() {
	local src=$1; shift
	local dst=$1; shift
	local cmd="$oggenc --quiet --utf8 -q $QUALITY -o $dst $src"
	[ -n "$VERBOSE" ] && echo "Running $cmd"
	[ -z "$DRYRUN" ] && $cmd
}

m4a2ogg() {
	local src=$1; shift
	local dst=$1; shift
	local cmd="$ffmpeg -i $src -c:a libvorbis -q:a $QUALITY -loglevel -8 $dst"
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
	if [ -n $FORCE ]; then
		linkcmd="$linkcmd -f"
	fi
	[ -z "$DRYRUN" ] && $linkcmd "$src" "$dst"
}

scan() {
	local count=0
	local intype infile outfile

	local total=$(wc -l <$M3U)

	while IFS= read -r infile; do
		count=$((count+1))
		if [ -n "$VERBOSE" ]; then
			echo "File $count: $infile"
		else
			printf "\r%d/%d" $count $total
		fi

		intype=${infile##*.}

		infile="$INBASE/$infile"
		outfile="${infile%.*}.$TYPE"
		outfile=$OUTBASE/${outfile#${INBASE}/}

		if [ ! -f "$infile" ]; then
			[ -n "$VERBOSE" ] && echo "Missing: $infile"
			continue
		fi

		if [ -z $FORCE ]; then
			if [ -f "$outfile" ]; then
				[ -n "$VERBOSE" ] && echo "Exists: $outfile"
				continue
			fi
		fi

		if [ ! -f "$outfile" ] || [ -z $FORCE ] || [ "$infile" -nt "$outfile" ]; then
			ensure_path $outfile
			if [ "$intype" = "$TYPE" ]; then
				copy "$infile" "$outfile"
			else
				"${intype}2${TYPE}" "$infile" "$outfile"
			fi
		fi
		touch -r "$infile" "$outfile"
	done < "$M3U"
	echo "\rProcessed $count lines"
}

main() {
	while getopts ":vflnr:q:t:" opt; do
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
			r) INBASE=$OPTARG
				;;
			?) usage
				;;
		esac
	done

    # Shift the rest
    shift $(($OPTIND - 1))

    M3U=$1; shift
    INBASE="${INBASE:-"/"}"
    OUTBASE=$(realpath ${1:-"./"})
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
