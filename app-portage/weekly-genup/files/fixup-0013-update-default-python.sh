#!/bin/bash
#
# fixup-0013-update-default-python.sh
#
# At the time of writing (14 Jul 2020) Python 3.7 has become the
# upstream default [1] and although the image still supports Python
# 3.6 (as a transitional measure), a (small) number of packages do not
# work correctly with it. Accordingly, this fixup checks if the
# default interpreter is 3.x (where x < 7) and if so, and 3.7 is also
# available, switches to it.
#
# A sentinel is written so the depclean is only tried once; so if the
# user switches their default python back (e.g. to 3.6), it will stick.
#
# [1] https://www.gentoo.org/support/news-items/2020-04-22-python3-7.html
#
# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

PCDIR="/etc/portage"
SENTINEL="${PCDIR}/.fixup-0013-done"

if [[ -f "${SENTINEL}" ]]; then
    echo "Sentinel file found: Python default update process already run"
    exit 0
fi

echo "Updating default Python interpreter to 3.7, if appropriate"
CP="$(eselect python show)"
if [[ "${CP}" =~ ^python3\.([[:digit:]]+) ]]; then
    if ((BASH_REMATCH[1] < 7)); then
        # looks like a candidate to replace, but do we have a 3.7 to
        # switch to?
        if grep -q '[[:space:]]python3.7$' <(eselect python list); then
            echo "Setting system python default to 3.7"
            if ! eselect python set python3.7; then
                echo "  Failed to update default interpreter!" >&2
                exit 1
            fi
        else
            echo "No Python 3.7 interpreter found!" >&2
            exit 1
        fi
    else
        echo "Default Python interpreter already >= 3.7"
    fi
else
    echo "Non 3.x default; not proceeding"
fi

echo -e "This sentinel file prevents fixup-0013 from trying to set the\ndefault Python interpreter to 3.7 a second time." > "${SENTINEL}"
