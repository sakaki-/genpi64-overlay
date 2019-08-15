#!/bin/bash
#
# fixup-0007-migrate-rpi3-overlay-to-genpi64.sh
#
# Perform migration of the rpi3-overlay to genpi64-overlay.
#
# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

OLD_RC="/etc/portage/repos.conf/rpi3.conf"
NEW_RC="/etc/portage/repos.conf/genpi64.conf"
OLD_REPO="/usr/local/portage/rpi3"
NEW_REPO="/usr/local/portage/genpi64"
PR_SYML="/etc/portage/make.profile"
OLD_TARGET="/usr/local/portage/rpi3/profiles/default/linux/arm64/17.0/desktop/rpi3"
NEW_TARGET="/usr/local/portage/rpi3/profiles/default/linux/arm64/17.0/desktop/genpi64"
echo "Ensuring that rpi3-overlay correctly migrated to genpi64-overlay"

if [[ -s "${OLD_RC}" ]]; then
    # update the repos.conf file
    echo "Updating repos.conf file"
    mv -fv "${OLD_RC}" "${NEW_RC}"
    sed -i -e 's#rpi3#genpi64#g' \
        -e 's#RPi3 SBC#RPi3 and RPi4 SBCs#g' \
        -e 's#for Gentoo#for 64-bit Gentoo#g' "${NEW_RC}"
    echo "Moving repo itself"
    mv -fv "${OLD_REPO}" "${NEW_REPO}"
    echo "Setting new origin URL for repo"
    sed -i -e 's#rpi3-overlay#genpi64-overlay#s' "${NEW_REPO}/.git/config"
    CURR_SYML="$(readlink --canonicalize "${PR_SYML}")"
    if [[ "${CURR_SYML}" == "OLD_TARGET" ]]; then
        unlink "${PR_SYML}"
        ln -s "${NEW_TARGET}" "${PR_SYML}"
        echo "Profile updated"
    else
        echo "Not using 17.0/desktop/rpi3 - profile unchanged"
    fi
fi
