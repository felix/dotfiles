#!/bin/sh

OPTIPNG="$(command -v optipng)"
ADVPNG="$(command -v advpng)"
PNGCRUSH="$(command -v pngcrush)"
JPEGOPTIM="$(command -v jpegoptim)"

for f in *; do
	printf '%s\n' "$f"
	case ${f##*.} in
		png)
			[ -n "$OPTIPNG" ] && $OPTIPNG -quiet -force -o7 "$f"
			[ -n "$ADVPNG" ] && $ADVPNG -z4 "$f"
			[ -n "$PNGCRUSH" ] && $PNGCRUSH -rem gAMA -rem alla -rem cHRM -rem iCCP -rem sRGB -rem time -brute -reduce -q -q -ow "$f"
			;;
		jpg|jpeg)
			[ -n "$JPEGOPTIM" ] && $JPEGOPTIM -f --strip-all "$f"
			;;
	esac
done
