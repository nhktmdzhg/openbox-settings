#!/usr/bin/env sh

export LANG='POSIX'
exec 2>/dev/null

NOTIFICATION_STATUS="$(dunstctl is-paused)"
NOTIFICATION_ICON=''
NOTIFICATION_ICON_PAUSED=''
if [ "${NOTIFICATION_STATUS}" = 'true' ]; then
    ICON="${NOTIFICATION_ICON_PAUSED}"
    MESSAGE='Notifications are enabled'
else
    ICON="${NOTIFICATION_ICON}"
    MESSAGE='Notifications are disabled'
fi
case "${1}" in
    i*)
        echo "${ICON}"
        ;;
    t*)
        notify-send -i ~/.local/share/icons/BeautyLine/apps/scalable/preferences-desktop-notification.svg "${MESSAGE}"
        sleep 1
        dunstctl set-paused toggle
        ;;
esac
exit ${?}

