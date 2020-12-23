#!/bin/bash
#
# fixup-0014-add-v3d-video-card.sh
#
# This script simply adds v3d to the VIDEO_CARDS USE expand variable in
# /etc/portage/make.conf.
#
# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

PCDIR="/etc/portage"
MC="${PCDIR}/make.conf"
SENTINEL="${PCDIR}/.fixup-0014-done"
RC=0

# short-circuit exit if we can; portageq takes some time to run
if [[ -f "${SENTINEL}" ]]; then
    echo "Sentinel file found: v3d already added to VIDEO_CARDS"
    exit $RC
fi

echo "Adding v3d to VIDEO_CARDS"

if ! grep -q '^VIDEO_CARDS.*v3d' "${MC}"; then
	sed -i -e 's#^VIDEO_CARDS="fbdev vc4"$#VIDEO_CARDS="fbdev vc4 v3d"#g' "${MC}"
	RC=$?
fi

if ((RC==0)); then
    echo -e "This sentinel file prevents fixup-0014 from trying to add v3d\nto VIDEO_CARDS a second time." > "${SENTINEL}"
fi

exit $RC
