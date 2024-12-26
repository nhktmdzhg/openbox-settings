#!/usr/bin/env sh

exec >/dev/null 2>&1
. "${HOME}/.joyfuld"

# https://gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#:~:text=expand_aliases
[ -z "$BASH" ] || shopt -s expand_aliases

{ [ "$(joyd_launch_apps -g terminal)" = 'urxvtc' ] && urxvtd -f -q; } &

joyd_restart_ui
joyd_tray_programs exec

picom --experimental-backends -b

if [ -x "$(command -v lxpolkit)" ]; then
    lxpolkit &
else
    $(find ${LIBS_PATH} -type f -iname 'polkit-gnome-authentication-agent-*' | sed 1q) &
fi

xss-lock -q -l "${JOYD_DIR}/xss-lock-tsl.sh" &

# Autostart app, below is my app, you can change by yourself
# discord &
# thunderbird &
xfce4-power-manager &
# mcontrolcenter &
flameshot &
# bottles-cli run -p Zalo -b 'Zalo' -- %u &
# bottles-cli run -p Unikey -b 'Zalo' -- %u &

