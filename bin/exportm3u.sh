#!/bin/sh

# Export files in M3U file to directory tree, recoding as necessary

# Author: Felix Hanley <felix@userspace.com.au>

set -u

M3U="${1:-"$HOME/Music/playlists/Favourites.m3u"}"
INBASE="${INBASE:-"$HOME/Music"}"
OUTBASE=$(realpath "${2:-"./"}")
QUALITY=${QUALITY:-7}
FORCE=
DRYRUN=
VERBOSE=
TYPE="${TYPE:-ogg}"

dirname=$(command -v dirname)
[ -z "$dirname" ] && printf "Missing dirname, cannot continue." && exit 1
readlink=$(command -v readlink)
[ -z "$readlink" ] && printf "Missing readlink, cannot continue." && exit 1
realpath=$(command -v realpath)
if [ -z "$realpath" ]; then
	# Provide a realpath implementation
	realpath() {
		canonicalize_path "$(resolve_symlinks "$1")"
	}
fi
flac=$(command -v flac)
[ -z "$flac" ] && printf "Missing flac, cannot continue."
oggenc=$(command -v oggenc)
[ -z "$oggenc" ] && printf "Missing oggenc, cannot continue."
lame=$(command -v lame)
[ -z "$lame" ] && printf "Missing lame, cannot continue."
ffmpeg=$(command -v ffmpeg)
[ -z "$ffmpeg" ] && printf "Missing ffmpeg, cannot continue."

usage() {
	printf 'Export files in an M3U playlist\n'
	printf 'usage: exportm3u [options] <m3u file> [output path]\n'
	printf '\nOptions:\n'
	printf '\t-v\tBe verbose\n'
	printf '\t-q\tQuality (0-10)\n'
	printf '\t-f\tForce overwriting existing files\n'
	printf '\t-r\trelative base path\n'
	printf '\t-t\tOutput type ogg (default), mp3, flac\n'
	printf '\t-n\tDry run\n'
	printf '\t-h\tThis help\n'
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
	rm -f "$2.partial"
	# prevent ffmpeg from readin stdin
	< /dev/null $ffmpeg -i "$1" -c:a libvorbis -q:a "$QUALITY" -loglevel quiet -f ogg "$2.partial"
	# $oggenc --quiet --utf8 -q "$QUALITY" -o "$2.partial" "$1"
	[ -f "$2.partial" ] && mv -f "$2.partial" "$2"
}
flac2flac() {
	cp -f "$1" "$2"
}
m4a2ogg() {
	$ffmpeg -i "$1" -c:a libvorbis -q:a "$QUALITY" -loglevel quiet "$2.partial" \
		&& mv -f "$2.partial" "$2"
	}
ogg2ogg() {
	cp -f "$1" "$2"
}
mp32ogg() {
	# TODO
	cp -f "$1" "$2"
}

ensure_path() {
	mkdir -p "$($dirname -- "$1")" > /dev/null
}

normalise_filename() {
	outfile="$(printf '%s' "$1" |iconv -f utf-8 -t ascii//translit |tr --squeeze-repeats ':&?*<>|; " ' '_')"
	printf '%s' "$outfile"
}

scan() {
	count=0
	while IFS= read -r inFileName; do

		intype=${inFileName##*.}

		infile="$INBASE/$inFileName"
		outfile="${infile%.*}.$TYPE"
		outfile=$OUTBASE/${outfile#"${INBASE}"/}
		outfile="$(normalise_filename "$outfile")"

		count=$((count+1))
		action="SKIPPING"

		if [ ! -f "$infile" ]; then
			# No source file, nothing to do
			action="MISSING"
		else
			if [ ! -f "$outfile" ]; then
				# No output
				action="WRITING"
			else
				if find "$infile" -prune -newer "$outfile" | grep -q '^'; then
					#if [ "$infile" -nt "$outfile" ]; then
					# Output is old
					action="WRITING"
				fi
			fi
			if [ -n "$FORCE" ]; then
				action="WRITING"
			fi
		fi

		printf "[%s] %s" "$action" "$inFileName"

		if [ "$action" = "WRITING" ]; then
			if [ -z "$DRYRUN" ]; then
				ensure_path "$outfile"
				"${intype}2${TYPE}" "$infile" "$outfile"
			fi
			#touch -r "$infile" "$outfile"
		fi

		if [ "$action" != "SKIPPING" ] || [ -n "$VERBOSE" ]; then
			printf '\n'
		else
			printf '\33[2K\r'
		fi

	done < "$M3U"
	printf '\33[2K\rProcessed %s files\n' "$count"
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
	shift $((OPTIND - 1))

	if [ ! -f "$M3U" ]; then
		printf 'Missing M3U file\n'
		usage
	fi

	scan
	find "$OUTBASE" -name '*.partial' -delete
}

main "$@"
