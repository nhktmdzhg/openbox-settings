#!/usr/bin/dash

export LANG='POSIX'
exec 2>/dev/null

# check the current windows is fullscreen or not, if is fullscreen, then turn off the notification
IS_FULLSCREEN="$(xprop -id "$(xdotool getactivewindow)" _NET_WM_STATE | grep -c _NET_WM_STATE_FULLSCREEN)"

if [ "${IS_FULLSCREEN}" -eq 1 ]; then
    dunstctl set-paused true
else
    dunstctl set-paused false
fi

NOTIFICATION_STATUS="$(dunstctl is-paused)"
NOTIFICATION_ICON=''
NOTIFICATION_ICON_PAUSED=''
if [ "${NOTIFICATION_STATUS}" = 'true' ]; then
    ICON="${NOTIFICATION_ICON_PAUSED}"
else
    ICON="${NOTIFICATION_ICON}"
fi
echo "${ICON}"
exit ${?}

