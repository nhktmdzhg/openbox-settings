#!/usr/bin/dash

export LANG='POSIX'
exec >/dev/null 2>&1

# Check if the music controller is already running
IS_RUNNING=$(rhythmbox-client --check-running)
if [ "${IS_RUNNING}" = "false" ]; then
    exit 1
fi

action="$1"
case "${action}" in
    prev)
        rhythmbox-client --previous
        ;;
    next)
        rhythmbox-client --next
        ;;
    toggle)
        rhythmbox-client --play-pause
        ;;
    stop)
        rhythmbox-client --stop
        ;;
    *)
        ;;
esac
exit 0

