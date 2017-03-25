#!/usr/bin/env zsh

i3status -c ~/.i3/i3status.conf | (read line && echo $line && while :
do
    read line
    dat=$(mpc current)
    dat="[{ \"color\": \"#859900\", \"full_text\": \"${dat}\" },"
    echo "${line/\[/$dat}" || exit 1
done)
