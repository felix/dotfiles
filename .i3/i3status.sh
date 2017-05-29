#!/bin/sh

i3status -c ~/.i3/i3status.conf | (read line && echo $line && while :
do
    read line
    dat=$(mpc current)
    if [ -z "${dat}" ]; then
        echo "$line" || exit 1
    else
        dat="[{ \"color\": \"#859900\", \"full_text\": \"${dat}\" },"
        echo "${dat} ${line#\[}" || exit 1
    fi
done)
