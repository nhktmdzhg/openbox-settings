#!/usr/bin/env sh

export LANG='POSIX'
exec 2>/dev/null
. "${HOME}/.joyfuld"

[ -x "$(command -v iwgetid)" -o -x "$(command -v ip)" ] || exec echo 'Install `wireless-tools` and/or `iproute2`!'

GET_ET="$(ip addr show "${IFACE_ET}")"
IP_ET="$(echo "${GET_ET}" | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)"
GET_WL="$(iwgetid "${IFACE_WL}")"
ESSID="$(iwgetid -r)"
if [ -n "$IP_ET" ]; then
    ICON=''
    STAT="${IP_ET}"
elif [ -n "$ESSID" ]; then
    ICON=''
    STAT="${ESSID}"
else
    ICON=''
    STAT="No Ethernet or Wi-Fi connected"
fi

case "${1}" in
    icon) echo "$ICON"
    ;;
    sta*) echo "$STAT"
    ;;
esac

exit ${?}
