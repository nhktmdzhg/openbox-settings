#!/usr/bin/env sh

export LANG='POSIX'
exec 2>/dev/null
. "${HOME}/.joyfuld"

[ -x "$(command -v upower)" ] || exit 1

BATTERRY_STATUS="$(upower -i $(upower -e | grep 'BAT') | grep -E "state" | awk '{print $2}')"
BATTERRY_PERCENTAGE="$(upower -i $(upower -e | grep 'BAT') | grep -E "percentage" | awk '{print $2}' | tr -d '%')"
BATTERRY_ICON=''
ICON_BATTERY_EMPTY=''
ICON_BATTERY_QUARTER=''
ICON_BATTERY_HALF=''
ICON_BATTERY_THREE_QUARTERS=''
ICON_BATTERY_FULL=''
ICON_BATTERY_CHARGING=''
if [ "${BATTERRY_STATUS}" = 'discharging' ]; then
    if [ "${BATTERRY_PERCENTAGE}" -le 10 ]; then
        BATTERRY_ICON="${ICON_BATTERY_EMPTY}"
    elif [ "${BATTERRY_PERCENTAGE}" -le 30 ]; then
        BATTERRY_ICON="${ICON_BATTERY_QUARTER}"
    elif [ "${BATTERRY_PERCENTAGE}" -le 50 ]; then
        BATTERRY_ICON="${ICON_BATTERY_HALF}"
    elif [ "${BATTERRY_PERCENTAGE}" -le 80 ]; then
        BATTERRY_ICON="${ICON_BATTERY_THREE_QUARTERS}"
    else
        BATTERRY_ICON="${ICON_BATTERY_FULL}"
    fi
else
    BATTERRY_ICON="${ICON_BATTERY_CHARGING}"
fi

echo "${BATTERRY_ICON}"
exit ${?}

