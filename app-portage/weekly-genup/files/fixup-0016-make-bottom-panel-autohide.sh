#!/bin/bash
#
# fixup-0016-make-bottom-panel-autohide.sh
#
# Turns on intelligent autohiding for the bottom panel, to maximise
# screen real estate.
#
# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

shopt -s nullglob

echo "Ensuring Xfce4 bottom panel intelligently autohides"
for UP in /home/*; do
    U="$(basename "${UP}")"
    G="$(id -gn "${U}")"
    PDIR="${UP}/.config/xfce4/panel"
    SENTINEL="${PDIR}/.fixup-0016-done"
    TARGET="${UP}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    if [[ -e "${SENTINEL}" || ! -s "${TARGET}" || ! -d "${PDIR}" ]]; then
        continue
    fi
    su - "${U}" --command='xfconf-query --channel xfce4-panel --property "/panels/panel-2/autohide-behavior" --create --type uint --set 1' &>/dev/null || true
    touch "${SENTINEL}"
    chown "${U}:${G}" "${SENTINEL}"
done
