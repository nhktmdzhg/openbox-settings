#!/usr/bin/dash

export LANG='POSIX'
exec >/dev/null 2>&1

AUDIO_DEVICE=$(pactl info | awk '/Default Sink:/ { print $3 }')
case "${1}" in
    +) pactl set-sink-volume "${AUDIO_DEVICE}" +5%
    ;;
    -) pactl set-sink-volume "${AUDIO_DEVICE}" -5%
    ;;
    0) pactl set-sink-mute "${AUDIO_DEVICE}" toggle
    ;;
esac

{
    AUDIO_VOLUME="$(pactl get-sink-volume "${AUDIO_DEVICE}" | grep -oP '\d+%' | tr -d '%' | head -n1)"
    AUDIO_MUTED="$(pactl get-sink-mute "${AUDIO_DEVICE}" | grep -oP 'yes')"

    if [ "$AUDIO_VOLUME" -eq 0 -o "$AUDIO_MUTED" = 'yes' ]; then
        [ -z "$AUDIO_MUTED" ] || MUTED='Muted'
        ICON='audio-volume-muted'
    elif [ "$AUDIO_VOLUME" -lt 30 ]; then
        ICON='audio-volume-low'
    elif [ "$AUDIO_VOLUME" -lt 70 ]; then
        ICON='audio-volume-medium'
    else
        ICON='audio-volume-high'
    fi

    exec dunstify ${MUTED:-"$AUDIO_VOLUME" -h "int:value:${AUDIO_VOLUME}"} \
                                           -a joyful_desktop \
                                           -h string:synchronous:audio-volume \
                                           -i "$ICON" \
                                           -t 1000
} &

exit ${?}
