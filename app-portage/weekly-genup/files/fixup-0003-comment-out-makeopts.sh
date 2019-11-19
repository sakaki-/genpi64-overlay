#!/bin/bash
#
# fixup-0003-comment-out-makeopts.sh
#
# In earlier versions of the gentoo-on-rpi3-64bit image, the
# (not-under-package-control) file /etc/portage/make.conf contained
# rather aggressive parallel build settings, that can cause the system
# to lock up (due to lack of memory) in certain conditions.
#
# This fixup simply comments the settings out in that file (provided
# the sentinel /etc/portage/.fixup-0003-done, which this fixup
# touches, is not found), allowing the default profile settings
# (much less aggressive) to be used by default.
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

SCRIPTDIR="$(portageq get_repo_path / rpi3)" || SCRIPTDIR="$(portageq get_repo_path / genpi64)"
SCRIPTDIR="${SCRIPTDIR}/app-portage/weekly-genup/files"
PATCHFILE="${SCRIPTDIR}/fixup-0003-comment-out-makeopts.patch"
PCDIR="/etc/portage"
MC="${PCDIR}/make.conf"
SENTINEL="${PCDIR}/.fixup-0003-done"
RC=0

if [[ -f "${MC}" ]]; then
    if [[ ! -f "${SENTINEL}" ]]; then
        if [[ -s "${PATCHFILE}" ]]; then
            # only patch if the file looks intact to begin with
            if grep -q "^MAKEOPTS=\"-j5 -l4\"$" "${MC}" && \
                    grep -q "^EMERGE_DEFAULT_OPTS=\"--jobs=5 --load-average=4\"$" "${MC}"; then
                echo "Patching ${MC} to remove explicit"
                echo "setting of MAKEOPTS and EMERGE_DEFAULT_OPTS"
                cd "${PCDIR}"
                if patch --strip=1 --forward --reject-file=- --quiet <"${PATCHFILE}"; then
                    echo "${MC} patched successfully!"
                else
                    echo "Failed to patch ${MC}! Please manually comment out" >&2
                    echo "any lines setting MAKEOPTS or EMERGE_DEFAULT_OPTS" >&2
                    echo "in that file. This check will not be retried." >&2
                    RC=1
                fi
            else
                echo "${MC} appears to have been manually edited - not patching"
            fi
            # write sentinel so the test doesn't get redone
            echo -e "This sentinel file prevents fixup-0003 from commenting out\nMAKEOPTS and EMERGE_DEFAULT_OPTS settings in ${MC}." > "${SENTINEL}"
        else
            echo "${PATCHFILE} not found: cannot patch!" >&2
        fi
    else
        echo "Sentinel file found: ${MC} already processed"
    fi
else
    echo "No ${MC} found" >&2
    RC=1
fi

exit $RC

