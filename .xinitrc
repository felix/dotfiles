#!/bin/sh

# load resources, to be sure
[ -x "$(command -v xrdb)" ] && xrdb -merge "$HOME/.Xresources"

xset s off
xset -b
xsetroot -solid "#000000"

#[ -f "$HOME/.profile" ] && . $HOME/.profile

# Source local fonts too
[ -d ~/.fonts ] && xset +fp ~/.fonts/

# Use both shift to toggle English, Thai and Lahu keyboards
setxkbmap -I"$HOME/.xkb -option grp:shifts_toggle,grp_led:scroll" "us,th,lhu" -print |xkbcomp -I"$HOME/.xkb" - "$DISPLAY"

# Use the left Windows key as compose
setxkbmap -option compose:lwin

# Disable touchscreen on X1
xinput disable "ELAN901C:00 04F3:2C71"

[ -x "$(command -v redshift)" ] && redshift -m randr -t 5500:3500 -l -37.8023217:145.1144633 &

# Screen control
if [ -x "$(command -v xautolock)" ]; then
	if [ -x "$(command -v xlock)" ]; then
		xautolock -time 5 -locker "xlock -modelist rain,space,pyro" &
	elif [ -x "$(command -v i3lock)" ]; then
		xautolock -time 5 -locker "i3lock -f -e -d -c 000000" &
	fi
fi

exec dbus-launch --sh-syntax --exit-with-session i3
