#!/usr/bin/dash
SYSTEM_LANG="$LANG"
export LANG='POSIX'
exec >/dev/null 2>&1

killall -q dunst
killall -q tint2
killall -q nitrogen
openbox --reconfigure &
dunst &
tint2 &
nitrogen --restore &

