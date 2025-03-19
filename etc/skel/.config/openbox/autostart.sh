#!/usr/bin/env sh

exec >/dev/null 2>&1
picom --experimental-backends -b
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
xss-lock -q -l ~/.config/openbox/joyful-desktop/xss-lock-tsl.sh &

# Autostart applications
dunst &
tint2 &
nitrogen --restore &
thunderbird &
mcontrolcenter &
flameshot &
bottles-cli run -p Zalo -b 'Zalo' -- %u &
discord &
bottles-cli run -p Unikey -b 'Zalo' -- %u &
fcitx5 &
nm-applet &
powerprofilesctl set performance &
bluetoothctl power off &

