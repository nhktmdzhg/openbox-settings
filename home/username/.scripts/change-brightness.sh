#!/usr/bin/env sh

export LANG='POSIX'
exec >/dev/null 2>&1

case "${1}" in
    +) brightnessctl set 5%+ -q
    ;;
    -) brightnessctl set 5%- -q
    ;;
esac


{
    BRIGHTNESS_VALUE="$(brightnessctl ${BRIGHTNESS_DEVICE:+-d "$BRIGHTNESS_DEVICE"} get)"
    MAX_BRIGHTNESS="$(brightnessctl ${BRIGHTNESS_DEVICE:+-d "$BRIGHTNESS_DEVICE"} max)"
    BRIGHTNESS=$(( BRIGHTNESS_VALUE * 100 / MAX_BRIGHTNESS ))
    if [ "$BRIGHTNESS" -lt 10 ]; then
        ICON='display-brightness-low'
    elif [ "$BRIGHTNESS" -lt 70 ]; then
        ICON='display-brightness-medium'
    else
        ICON='display-brightness-high'
    fi

    exec dunstify "$BRIGHTNESS" -h "int:value:${BRIGHTNESS}" \
                                -a joyful_desktop \
                                -h string:synchronous:display-brightness \
                                -i "$ICON" \
                                -t 1000
} &

exit ${?}

