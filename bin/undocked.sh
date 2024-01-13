#!/bin/sh
xrandr \
	--output eDP1 --primary --mode 1920x1200 --pos 0x0 --rotate normal \
	--output DP1 --off \
	--output DP2 --off \
	--output DP3 --off \
	--output DP3-1 --off \
	--output DP3-2 --off \
	--output DP3-3 --off \
	--output DP4 --off \
	--output HDMI1 --off \
	--output HDMI2 --off \
	--output HDMI3 --off \
	--output VIRTUAL1 --off

xbacklight -set 5
