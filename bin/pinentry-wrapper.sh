#!/bin/sh

pe=/usr/bin/pinentry-qt

case "$PINENTRY_USER_DATA" in
*USE_CURSES*) pe=/usr/bin/pinentry-curses ;;
*USE_GTK2*)   pe=/usr/bin/pinentry-gtk-2 ;;
*USE_GNOME3*) pe=/usr/bin/pinentry-gnome3 ;;
*USE_X11*)    pe=/usr/bin/pinentry-x11 ;;
*USE_QT*)     pe=/usr/bin/pinentry-qt ;;
*USE_TTY*)    pe=/usr/bin/pinentry-tty  ;;
#*)    printf '%s\n' "$PINENTRY_USER_DATA" >> /tmp/pinentry.log ;;
esac
exec $pe "$@"
