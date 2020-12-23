#!/bin/bash
#
# fixup-0005-ensure-hwclock-disabled.sh
#
# The RPi3 has now battery-backed RTC, so the hwclock
# service will fail if called. Ensure it is disabled.
#
# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

echo "Ensuring hwclock service is disabled"
if [[ -L /etc/runlevels/boot/hwclock ]]; then
    rc-update del hwclock boot
fi
