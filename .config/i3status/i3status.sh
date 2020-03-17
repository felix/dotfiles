#!/bin/sh

hostname=$(hostname |cut -d. -f1)

#i3status -c ~/.i3/i3status-${hostname}.conf | (read line && echo $line && read line && echo $line && read line && echo $line && while :
# do
#     read line
#     dat=$(mpc current)
#     echo ",[{ \"color\": \"#859900\", \"full_text\": \"${dat}\" }, ${line#,\[}" || exit 1
# done)
py3status -c ~/.config/i3status/${hostname}.conf
