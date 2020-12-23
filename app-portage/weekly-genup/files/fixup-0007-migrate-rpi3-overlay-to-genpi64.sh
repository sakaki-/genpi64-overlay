#!/bin/bash
#
# fixup-0007-migrate-rpi3-overlay-to-genpi64.sh
#
# Perform migration of the rpi3-overlay to genpi64-overlay.
#
# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

OLD_RC="/etc/portage/repos.conf/rpi3.conf"
NEW_RC="/etc/portage/repos.conf/genpi64.conf"
OLD_REPO="/usr/local/portage/rpi3"
NEW_REPO="/usr/local/portage/genpi64"
PR_SYML="/etc/portage/make.profile"
OLD_TARGET="/usr/local/portage/rpi3/profiles/default/linux/arm64/17.0/desktop/rpi3"
NEW_TARGET="/usr/local/portage/genpi64/profiles/default/linux/arm64/17.0/desktop/genpi64"
echo "Ensuring that rpi3-overlay correctly migrated to genpi64-overlay"
CURR_SYML="$(readlink --canonicalize "${PR_SYML}")"

if [[ -s "${OLD_RC}" ]]; then
    # update the repos.conf file
    echo "Updating repos.conf file"
    mv -fv "${OLD_RC}" "${NEW_RC}"
    sed -i -e 's#rpi3#genpi64#g' \
        -e 's#RPi3 SBC#RPi3 and RPi4 SBCs#g' \
        -e 's#for Gentoo#for 64-bit Gentoo#g' "${NEW_RC}"
    echo "Setting new origin URL for repo"
    sed -i -e 's#rpi3-overlay#genpi64-overlay#g' "${OLD_REPO}/.git/config"
    if [[ "${CURR_SYML}" == "${OLD_TARGET}" ]]; then
        unlink "${PR_SYML}"
        ln -s "${NEW_TARGET}" "${PR_SYML}"
        echo "Profile updated"
    else
        echo "Not using 17.0/desktop/rpi3 - profile unchanged"
        echo "Profile link: ${CURR_SYML}"
    fi
    echo "Moving repo itself"
    mv -fv "${OLD_REPO}" "${NEW_REPO}"
    echo "Fixing up package database"
    find "/var/db/pkg" -mindepth 3 -maxdepth 3 -type f \
         -name repository -exec \
         sed -i -e 's#^rpi3$#genpi64#g' {} +
    echo "Done! Run 'eix-sync -0' to update eix cache"
fi
