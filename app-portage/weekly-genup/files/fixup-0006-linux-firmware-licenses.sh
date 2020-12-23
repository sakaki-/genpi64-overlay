#!/bin/bash
#
# fixup-0006-linux-firmware-licenses.sh
#
# Ensure that appropriate licenses are enabled for the linux-firmware
# package (account for new linux-fw-redistributable license).
#
# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

LF="/etc/portage/package.license/linux-firmware"
echo "Ensuring linux-firmware allowed licenses are up-to-date"

if [[ -s "${LF}" ]]; then
    if ! grep -q "linux-fw-redistributable" 2>/dev/null "${LF}"; then
        sed -i 's#^sys-kernel/linux-firmware freedist#sys-kernel/linux-firmware freedist linux-fw-redistributable#' "${LF}"
    fi
fi
