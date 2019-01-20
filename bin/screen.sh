#!/bin/sh

hostname=$(hostname |cut -d. -f1)

[ "$hostname" = "bowie" ] && xrandr --output HDMI-1 --off --output DP-1 --mode 1920x1080 --pos 0x0 --rotate normal --output eDP-1 --mode 1920x1080 --pos 984x1080 --rotate normal --output DP-2 --mode 1920x1080 --pos 1920x0 --rotate normal
