#!/bin/sh

case $(uname |cut -f1) in
	Darwin)
		exit
		;;
	*)
		. $HOME/.xsessionrc
		exec dbus-launch --sh-syntax --exit-with-session i3
		;;
esac
