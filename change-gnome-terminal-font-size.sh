#!/bin/bash

# set -x

# File name
readonly PROGNAME=$(basename $0)

usage() {
	echo "Script to change font gnome-terminal font size. Tested on Ubuntu 22"
	echo
	echo "Usage: $PROGNAME -f <font> -s <size>"
	echo
	echo "Options:"
	echo
	echo "  -h, --help"
	echo "      This help text."
	echo
	echo "  -f <string>, --font <string>"
	echo "      Font."
	echo
	echo "  -s <file>, --size <file>"
	echo "      Font size."
	echo
	echo "  --"
	echo "      Do not interpret any more arguments as options."
	echo
}

while [ "$#" -gt 0 ]
do
	case "$1" in
	-h|--help)
		usage
		exit 0
		;;
	-f|--font)
		font="$2"
		shift
		;;
	-s|--size)
		size="$2"
		;;
	--)
		break
		;;
	-*)
		echo "Invalid option '$1'. Use --help to see the valid options" >&2
		exit 1
		;;
	# an option argument, continue
	*)	;;
	esac
	shift
done

( [ -z $font ] || [ -z $size ] ) && echo "see --help for correct arguments usage" >&2 && exit 1

# get profile id
profile_id=$(gsettings get org.gnome.Terminal.ProfilesList list | tr -d "[]'")
dbus-run-session gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/ use-system-font false
dbus-run-session gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile_id/ font "$font $size"
