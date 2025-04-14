#!/usr/bin/env sh

SYSTEM_LANG="$LANG"
export LANG='POSIX'
exec >/dev/null 2>&1

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus

LANG="$SYSTEM_LANG" \
exec rofi -theme-str '@import "main.rasi"' \
          -no-lazy-grab \
          -show drun

exit ${?}

