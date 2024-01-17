#!/bin/sh

# XDG setup
if [ -z "$XDG_RUNTIME_DIR" ]; then
	export XDG_RUNTIME_DIR="/tmp/$USER-xdg-runtime"
	mkdir -p "$XDG_RUNTIME_DIR"
	chmod 700 "$XDG_RUNTIME_DIR"
fi

#dbus-daemon --session --address=unix:path=$XDG_RUNTIME_DIR/bus &

[ -x "$(command -v alacritty)" ] && export TERMINAL=alacritty
[ -x "$(command -v firefox)" ] && export BROWSER=firefox
[ -x "$(command -v pipewire)" ] && dbus-run-session pipewire &

export PASSWORD_STORE_X_SELECTION=primary
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM=wayland-egl
export ELM_DISPLAY=wl
export SDL_VIDEODRIVER=wayland

# This will also be configured via .xinitrc
#exec startx

exec dbus-run-session sway
