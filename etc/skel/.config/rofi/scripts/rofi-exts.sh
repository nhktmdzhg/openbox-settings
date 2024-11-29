#!/usr/bin/env sh

# Desc:   Run rofi-extensions menu with custom modi.
# Author: Harry Kurn <alternate-se7en@pm.me>
# URL:    https://github.com/owl4ce/dotfiles/tree/ng/.config/rofi/scripts/rofi-exts.sh

# SPDX-License-Identifier: ISC

SYSTEM_LANG="$LANG"
export LANG='POSIX'
exec >/dev/null 2>&1

SYSINFO=''
SESSION=''
MEDIA=''
MUSIC=''
PERFORMANCE=''

CUSTOM_MODI="\
${SYSINFO}:${0%/*}/custom-modi/modi-sysinfo.sh,\
${SESSION}:${0%/*}/custom-modi/modi-session.sh,\
${MEDIA}:${0%/*}/custom-modi/modi-media.sh,\
${MUSIC}:${0%/*}/custom-modi/modi-music.sh,\
${PERFORMANCE}:${0%/*}/custom-modi/modi-performance.sh"

case "${1}" in
    sys*) MODI="$SYSINFO"
    ;;
    ses*) MODI="$SESSION"
    ;;
    med*) MODI="$MEDIA"
    ;;
    mus*) MODI="$MUSIC"
    ;;
    per*) MODI="$PERFORMANCE"
    ;;
esac

SYSTEM_LANG="$SYSTEM_LANG" \
exec rofi -theme-str '@import "exts.rasi"' \
          -modi "$CUSTOM_MODI" \
          -no-show-icons \
          -no-lazy-grab \
          -no-plugins \
          -kb-custom-19 '' \
          -kb-move-char-back '' \
          -kb-move-char-forward '' \
          -kb-mode-previous 'Left' \
          -kb-mode-next 'Right' \
          -show "${MODI:-${SYSINFO}}"

exit ${?}
