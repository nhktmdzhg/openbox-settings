#!/usr/bin/env sh
SYSTEM_LANG="$LANG"
export LANG='POSIX'
exec >/dev/null 2>&1
. "${HOME}/.joyfuld"

openbox --reconfigure &
dunst -config "${DUNST_DIR}/mechanical.interactive.dunstrc" &
joyd_terminal_set &
nitrogen --restore &
tint2 -c "${TINT2_DIR}/mechanical-top.interactive.tint2rc" &

