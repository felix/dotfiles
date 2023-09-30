#!/bin/sh

. $HOME/.xsessionrc
exec dbus-launch --sh-syntax --exit-with-session i3
