#!/usr/bin/dash

export LANG='POSIX'
exec >/dev/null 2>&1

action="$1"
case "${action}" in
    prev)
        playerctl previous
        ;;
    next)
        playerctl next
        ;;
    stop)
        playerctl stop
        ;;
    play)
        playerctl play-pause
        ;;
    pause)
        playerctl play-pause
        ;;
    *)
        ;;
esac
exit 0

