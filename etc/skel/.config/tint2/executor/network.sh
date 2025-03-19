#!/usr/bin/env sh

export LANG='POSIX'
exec 2>/dev/null

GET_ET="$(ip addr show enp4s0)"
IP_ET="$(echo "${GET_ET}" | grep 'inet ' | awk '{print $2}' | cut -d'/' -f1)"
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
