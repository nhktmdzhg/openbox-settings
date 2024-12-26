#!/usr/bin/env sh

export LANG='POSIX'
exec 2>/dev/null
. "${HOME}/.joyfuld"

case "$ROFI_RETV" in
    28) LANG="$SYSTEM_LANG" exec "${0%/*}/../rofi-main.sh"
    ;;
esac

ROW_ICON_FONT='feather 12'
MSG_ICON_FONT='feather 48'

B_='' B="<span font_desc='${ROW_ICON_FONT}' weight='bold'>${B_}</span>   Increase ${AUDIO_VOLUME_STEPS}%"
C_='' C="<span font_desc='${ROW_ICON_FONT}' weight='bold'>${C_}</span>   Decrease ${AUDIO_VOLUME_STEPS}%"
D_='' D="<span font_desc='${ROW_ICON_FONT}' weight='bold'>${D_}</span>   Toggle mute"
F_='' F="<span font_desc='${ROW_ICON_FONT}' weight='bold'>${F_}</span>   Brighten ${BRIGHTNESS_STEPS}%"
G_='' G="<span font_desc='${ROW_ICON_FONT}' weight='bold'>${G_}</span>   Dim ${BRIGHTNESS_STEPS}%"

case "${@}" in
    "$B") ~/.scripts/change-volume.sh +
    ;;
    "$C") ~/.scripts/change-volume.sh -
    ;;
    "$D") ~/.scripts/change-volume.sh 0
    ;;
    "$F") ~/.scripts/change-brightness.sh +
    ;;
    "$G") ~/.scripts/change-brightness.sh -
    ;;
esac

AUDIO_DEVICE="$(pactl list sinks | grep -B1 -A9 State: | grep 'Name: ' | cut -d' ' -f2)"
AUDIO_VOLUME="$(pactl get-sink-volume "${AUDIO_DEVICE}" | grep -oP '\d+%' | tr -d '%' | head -n1)"
AUDIO_MUTED="$(pactl get-sink-mute "${AUDIO_DEVICE}" | grep -oP 'yes')"

BRIGHTNESS_VALUE="$(brightnessctl ${BRIGHTNESS_DEVICE:+-d "$BRIGHTNESS_DEVICE"} get)"
MAX_BRIGHTNESS="$(brightnessctl ${BRIGHTNESS_DEVICE:+-d "$BRIGHTNESS_DEVICE"} max)"
BRIGHTNESS=$(( BRIGHTNESS_VALUE * 100 / MAX_BRIGHTNESS ))
if [ "$AUDIO_VOLUME" -eq 0 -o "$AUDIO_MUTED" = 'yes' ]; then
    [ -z "$AUDIO_MUTED" ] || MUTED='Muted'
    A_=''
elif [ "$AUDIO_VOLUME" -lt 30 ]; then
    A_=''
elif [ "$AUDIO_VOLUME" -lt 70 ]; then
    A_=''
else
    A_=''
fi

A="<span font_desc='${ROW_ICON_FONT}' weight='bold'>${A_}</span>   ${MUTED-${AUDIO_VOLUME}}"
E_='' E="<span font_desc='${ROW_ICON_FONT}' weight='bold'>${E_}</span>   ${BRIGHTNESS}"

MESSAGE="<span font_desc='${MSG_ICON_FONT}' weight='bold'></span>"

printf '%b\n' '\0use-hot-keys\037true' '\0markup-rows\037true' "\0message\037${MESSAGE}" \
              "${A}\0nonselectable\037true" "$B" "$C" "$D" "${E}\0nonselectable\037true" "$F" "$G"

exit ${?}

