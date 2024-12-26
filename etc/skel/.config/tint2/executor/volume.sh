#!/usr/bin/env sh

export LANG='POSIX'
exec 2>/dev/null
. "${HOME}/.joyfuld"

AUDIO_DEVICE="$(pactl list sinks | grep -B1 -A9 State: | grep 'Name: ' | cut -d' ' -f2)"
case "${1}" in
    +) pactl set-sink-volume "${AUDIO_DEVICE}" +5%
    ;;
    -) pactl set-sink-volume "${AUDIO_DEVICE}" -5%
    ;;
    0) pactl set-sink-mute "${AUDIO_DEVICE}" toggle
    ;;
esac

AUDIO_VOLUME="$(pactl get-sink-volume "${AUDIO_DEVICE}" | grep -oP '\d+%' | tr -d '%' | head -n1)"
AUDIO_MUTED="$(pactl get-sink-mute "${AUDIO_DEVICE}" | grep -oP 'yes')"
if [ "$AUDIO_VOLUME" -eq 0 -o "$AUDIO_MUTED" = 'yes' ]; then
    [ -z "$AUDIO_MUTED" ] || MUTED='Muted'
    ICON=''
elif [ "$AUDIO_VOLUME" -lt 30 ]; then
    ICON=''
elif [ "$AUDIO_VOLUME" -lt 70 ]; then
    ICON=''
else
    ICON=''
fi

case "${1}" in
    icon) echo "${ICON:-?}"
    ;;
    per*) echo "${MUTED:-${AUDIO_VOLUME}}"
    ;;
esac

exit ${?}
