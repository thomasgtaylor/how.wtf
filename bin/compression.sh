#!/usr/bin/env sh

PNG_LEVEL=4
MAX_WIDTH=1400
MAX_JPG_SIZE=250

exiftool -all= public/images* -overwrite_original
for i in public/images/*; do
	mogrify -resize "$MAX_WIDTH>" "$i"
	case "$i" in
		*.png) optipng -f4 -clobber -strip all -o $PNG_LEVEL -quiet "$i" ;;
		*.jpeg|*.jpg) jpegoptim --strip-all --size=$MAX_JPG_SIZE -quiet "$i" ;;
	esac
done
