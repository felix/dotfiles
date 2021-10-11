#!/bin/sh


case $(hostname |cut -d. -f1) in
	C02Y3077JG5J)
		exit
		;;
	*)
		. $HOME/.xsessionrc
		exec dbus-launch --sh-syntax --exit-with-session i3
		;;
esac
