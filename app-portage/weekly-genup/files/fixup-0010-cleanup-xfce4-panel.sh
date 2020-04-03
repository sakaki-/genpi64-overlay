#!/bin/bash
#
# fixup-0010-cleanup-xfce4-panel.sh
#
# Ensure that the Xfce4 top panel display looks neat, even with the
# transition to >=xfce4-base/xfce4-panel-14.
#
# Sets tightly packed icons in, and removes frame line around, indicator area.
# Cleans up any cpugraph plugins.
#
# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

shopt -s nullglob

declare -i PLUGIN_MODIFIED=0

echo "Cleaning up Xfce4 panel"
for UP in /home/*; do
    U="$(basename "${UP}")"
    G="$(id -gn "${U}")"
    PDIR="${UP}/.config/xfce4/panel"
    SENTINEL="${PDIR}/.fixup-0010-done"
    TARGET="${UP}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
    if [[ -e "${SENTINEL}" || ! -s "${TARGET}" || ! -d "${PDIR}" ]]; then
        continue
    fi
    su - "${U}" --command='PLUGIN=$(xfconf-query --channel xfce4-panel --list --verbose | grep systray | cut -d " " -f 1); xfconf-query --channel xfce4-panel --property "${PLUGIN}/square-icons" --create --type bool --set false; xfconf-query --channel xfce4-panel --property "${PLUGIN}/show-frame" --create --type bool --set false' &>/dev/null || true
    for PLUGIN in "${PDIR}/cpugraph-"*.rc*; do
        sed -i 's/^Frame=1/Frame=0/;s/^Border=0/Border=1/' "${PLUGIN}"
    done
    touch "${SENTINEL}"
    chown "${U}:${G}" "${SENTINEL}"
    PLUGIN_MODIFIED=1
done
if ((PLUGIN_MODIFIED==1)); then
    # force panel plugin reload
    pkill -f -HUP libcpugraph
fi



