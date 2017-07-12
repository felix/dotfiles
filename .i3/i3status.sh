#!/bin/sh

i3status -c ~/.i3/i3status.conf | (read line && echo $line && read line && echo $line && read line && echo $line && while :
do
    read line
    dat=$(mpc current)
    echo ",[{ \"color\": \"#859900\", \"full_text\": \"${dat}\" }, ${line#,\[}" || exit 1
done)
