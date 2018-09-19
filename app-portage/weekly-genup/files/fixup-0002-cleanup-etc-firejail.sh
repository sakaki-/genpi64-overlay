#!/bin/bash
#
# fixup-0002-cleanup-etc-firejail.sh
#
# Upgrading to sys-apps/firejail-0.9.54 can leave a massive number
# (>400) of config file 'changes' to be merged in /etc/firejail.
#
# Since these are all just new profiles, and none are overwrites, they
# *should* just be silently installed, but for some reason the Gentoo
# CONFIG_PROTECT system gets confused in this instance (on the
# gentoo-on-rpi3-64bit image anyhow).
#
# This can be overwhelming for new users trying to run dispatch-conf
# or etc-update.
#
# Accordingly, this script just auto-merges all such
# ._cfg0000_<filename> files in /etc/firejail, for which no
# /etc/firejail/<filename> counterpart exists.
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

FJDIR="/etc/firejail"

shopt -s nullglob

if [[ -d "${FJDIR}" ]]; then
    cd "${FJDIR}"
    echo "Automerging new content in ${FJDIR}"
    for NEXTEDIT in ._cfg0000_*; do
        NEXTFILE="${NEXTEDIT#._cfg0000_}" # extract filename
        if [[ ! -e "${NEXTFILE}" ]]; then
            mv -v "${NEXTEDIT}" "${NEXTFILE}"
        fi
    done
else
    echo "No ${FJDIR} directory found" >&2
    exit 1
fi

