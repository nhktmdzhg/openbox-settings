#!/usr/bin/dash

exec >/dev/null 2>&1
wmname "iamnanokaWM"
picom -b
lxqt-policykit-agent &
xss-lock -q -l ~/.config/openbox/joyful-desktop/xss-lock-tsl.sh &

# Turn off screen idle
xset s off
xset -dpms

# Autostart applications
dunst &
tint2 &
nitrogen --restore &
thunderbird &
mcontrolcenter &
bottles-cli run -p Zalo -b 'Zalo' -- %u &
discord &
bottles-cli run -p Unikey -b 'Zalo' -- %u &
fcitx5 &
nm-applet &
powerprofilesctl set performance &
bluetoothctl power off &

