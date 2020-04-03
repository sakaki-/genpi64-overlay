#!/bin/bash
#
# fixup-0011-depclean-porthole.sh
#
# The Portage front end porthole has been tree-cleaned (Gentoo bug #708096).
# The last-known-good ebuild has been migrated to the sakaki-tools repo,
# but is now preventing sys-apps/portage from upgrading. Accordingly, this
# fixup depcleans it. A sentinel is written so the depclean is only tried once;
# if the user re-installs porthole, it will stick.
#
# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

PCDIR="/etc/portage"
SENTINEL="${PCDIR}/.fixup-0011-done"

if [[ -f "${SENTINEL}" ]]; then
    echo "Sentinel file found: porthole already depcleaned"
    exit 0
fi

echo "Depcleaning app-portage/porthole (bug #708096)"
emerge --depclean app-portage/porthole || emerge --deselect app-portage/porthole

echo -e "This sentinel file prevents fixup-0011 from trying to depclean\napp-portage/porthole a second time." > "${SENTINEL}"
