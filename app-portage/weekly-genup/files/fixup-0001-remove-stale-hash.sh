#!/bin/bash
#
# fixup-0001-remove-stale-hash.sh
#
# Remove any repo.hash{,.asc} files in /usr/portage/local that are
# older than their versions in /usr/portage, if they exist (can cause
# sync to fail)
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

PDIR="$(portageq get_repo_path / gentoo)"
PLDIR=${PDIR}/local

echo "Purging any stale repo.hash{,.asc} files from ${PLDIR}"
for F in repo.hash{,.asc}; do
    if [[ -f "${PDIR}/${F}" && -f "${PLDIR}/${F}" && "${PLDIR}/${F}" -ot "${PDIR}/${F}" ]]; then
        echo "Removing stale ${PDIR}/${F}"
        rm -fv "${PLDIR}/${F}"
    fi
done
