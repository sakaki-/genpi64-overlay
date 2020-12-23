#!/bin/bash
#
# fixup-0008-turn-off-dpms.sh
#
# Ensure that Xfce4-driven display power management
# is turned off (as this can cause puzzling blanking during e.g.
# genup runs). Writes a sentinel, so that the operation is not
# attempted twice.
#
# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

shopt -s nullglob

echo "Ensuring Xfce4-driven DPMS is (initially) off"
for UP in /home/*; do
    U="$(basename "${UP}")"
    SENTINEL="${UP}/.dpms-fixup-already-run"
    TARGET="${UP}/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-power-manager.xml"
    if [[ -e "${SENTINEL}" || ! -s "${TARGET}" ]]; then
        continue
    fi
    sed -i -e 's#<property name="dpms-enabled" type="bool" value="true"/>#<property name="dpms-enabled" type="bool" value="false"/>#g' "${TARGET}"
    G="$(id -gn "${U}")"
    touch "${SENTINEL}"
    chown "${U}:${G}" "${SENTINEL}"
done
