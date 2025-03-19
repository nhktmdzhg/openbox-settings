#!/usr/bin/env sh
SYSTEM_LANG="$LANG"
export LANG='POSIX'
exec >/dev/null 2>&1

killall -q dunst
killall -q tint2
openbox --reconfigure &
dunst &
tint2 &
nitrogen --restore &

