#!/bin/bash
#
# fixup-0012-modprobe-snd_bcm2835.sh
#
# On RPi3B/B+ systemd snd_bcm2835 can fail to load under rpi-5.4.y
# kernels, even when dtparam=audio=on is set in /boot/config.txt; this
# fixup forces the module load; a sentinel is used to ensure it only
# tries once.
#
# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

PCDIR="/etc/portage"
SENTINEL="${PCDIR}/.fixup-0012-done"

if [[ -f "${SENTINEL}" ]]; then
    echo "Sentinel file found: snd_bcm2835 module autoload already set"
    exit 0
fi

if [[ -s "/boot/config.txt" ]] && grep -q '^dtparam=audio=on' "/boot/config.txt" && [[ -e "/etc/conf.d/modules" ]]; then
    if grep -q '^modules_5_4="snd_bcm2835"' "/etc/conf.d/modules"; then
        echo "snd_bcm2835 module already autoloaded"
    else
        echo "Setting snd_bcm2835 module to autoload"
	echo 'modules_5_4="snd_bcm2835"' >> "/etc/conf.d/modules"
    fi
else
    echo "Not setting snd_bcm2835 module autoload"
fi

echo -e "This sentinel file prevents fixup-0012 from running\na second time." > "${SENTINEL}"
