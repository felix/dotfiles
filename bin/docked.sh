#!/bin/sh

xrandr --newmode "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
xrandr --addmode DP3-1 1920x1200_60.00
xrandr --addmode DP3-2 1920x1200_60.00

# Dual external monitors
xrandr --output DP3-2 --mode 1920x1200_60.00 --pos 0x0 --rotate left
xrandr --output eDP1  --mode 1920x1200 --pos 297x1920 --rotate normal --primary
xrandr --output DP3-1 --mode 1920x1200_60.00 --pos 1200x720 --rotate normal

# Single external monitor
# xrandr --output eDP1 --primary --mode 1920x1200 --pos 0x1200 --rotate normal \
# 	--output DP3-1 --mode 1920x1200 --pos 0x0 --rotate normal \

xbacklight -set 60
