#!/bin/bash
#
# fixup-0015-cleanup-xfce4-indicator-area.sh
#
# Ensure that the Xfce4 top panel display indicator area looks neat
# ensuring a 32-pixel top panel height, with autosized icons inside.
#
# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

shopt -s nullglob

echo "Cleaning up Xfce4 top panel indicator area icons"
for UP in /home/*; do
    U="$(basename "${UP}")"
    G="$(id -gn "${U}")"
    PDIR="${UP}/.config/xfce4/panel"
    SENTINEL="${PDIR}/.fixup-0015-done"
    TARGET="${UP}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    if [[ -e "${SENTINEL}" || ! -s "${TARGET}" || ! -d "${PDIR}" ]]; then
        continue
    fi
    su - "${U}" --command='PLUGIN=$(xfconf-query --channel xfce4-panel --list --verbose | grep systray | head -n 1 | cut -d " " -f 1); xfconf-query --channel xfce4-panel --property "/panels/panel-1/size" --create --type uint --set 32; xfconf-query --channel xfce4-panel --property "${PLUGIN}/icon-size" --create --type uint --set 0' &>/dev/null || true
    touch "${SENTINEL}"
    chown "${U}:${G}" "${SENTINEL}"
done
