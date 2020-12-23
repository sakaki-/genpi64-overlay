#!/bin/bash
#
# fixup-0009-migrate-portage-paths.sh
#
# The default paths used by by Portage have recently changed, as
# follows:
#   /usr/portage -> /var/db/repos/gentoo
#   /usr/portage/distfiles -> /var/cache/distfiles
#   /usr/portage/packages -> /var/cache/binpkgs
#   /usr/local/portage/<overlay> -> /var/db/repos/<overlay>
#
# This script simply checks if the old paths are currently being
# used and, if so, changes them over. It will edit the file
# /etc/portage/make.conf, and any
# /etc/portage/repos.conf/<overlay>.conf files too. Layman overlays
# are not moved. The current profile will be re-established at the end,
# to ensure the /etc/portage/make.profile link still refers.
#
# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

PCDIR="/etc/portage"
MC="${PCDIR}/make.conf"
PORTDIR="/usr/portage"
DISTDIR="/usr/portage/distfiles"
PKGDIR="/usr/portage/packages"
NEWRDIR="/var/db/repos"
NEWPORTDIR="${NEWRDIR}/gentoo"
NEWDISTDIR="/var/cache/distfiles"
NEWPKGDIR="/var/cache/binpkgs"
RCONFDIR="${PCDIR}/repos.conf"
SENTINEL="${PCDIR}/.fixup-0009-done"
RC=0

# short-circuit exit if we can; portageq takes some time to run
if [[ -f "${SENTINEL}" ]]; then
    echo "Sentinel file found: files already migrated"
    exit $RC
fi

echo "Migrating Portage paths to new defaults"

# get current state via portage
CURRPORTDIR="$(portageq get_repo_path / gentoo)"
CURRPKGDIR="$(portageq pkgdir)"
CURRDISTDIR="$(portageq distdir)"

# archive the canonicalized old profile name too
# as its symlink will break when we migrate
CURRPROFILE="$(eselect profile show | tr -d '\n \t')"
CURRPROFILE="${CURRPROFILE##*symlink:}"

shopt -s nullglob

if [[ ! -d "${NEWPKGDIR}" ]] && [[ -d "${PKGDIR}" ]] && [[ "${CURRPKGDIR}" == "${PKGDIR}" ]]; then
    echo "Migrating ${PKGDIR} -> ${NEWPKGDIR}"
    # leave symlink for safety
    mv "${PKGDIR}" "${NEWPKGDIR}" || RC=1
    ln -s "${NEWPKGDIR}" "${PKGDIR}"
    if grep -q "^[[:space:]]*PKGDIR=" "${MC}" &>/dev/null; then
        # variable is explicitly set in make.conf, update it
        sed -i -e 's#^\s*PKGDIR=.*$#XXX-xx-XXX#g' -e "s#XXX-xx-XXX#PKGDIR=${NEWPKGDIR}#g" "${MC}"
    else
        # variable not explicitly set in make.conf
        echo "PKGDIR=${NEWPKGDIR}" >> "${MC}"
    fi
fi

if [[ ! -d "${NEWDISTDIR}" ]] && [[ -d "${DISTDIR}" ]] && [[ "${CURRDISTDIR}" == "${DISTDIR}" ]]; then
    echo "Migrating ${DISTDIR} -> ${NEWDISTDIR}"
    mv "${DISTDIR}" "${NEWDISTDIR}" || RC=1
    # leave symlink for safety
    ln -s "${NEWDISTDIR}" "${DISTDIR}"
    if grep -q "^[[:space:]]*DISTDIR=" "${MC}" &>/dev/null; then
        # variable is explicitly set in make.conf, update it
        sed -i -e 's#^\s*DISTDIR=.*$#XXX-xx-XXX#g' -e "s#XXX-xx-XXX#DISTDIR=${NEWDISTDIR}#g" "${MC}"
    else
        # variable not explicitly set in make.conf
        echo "DISTDIR=${NEWDISTDIR}" >> "${MC}"
    fi
fi

for NEXTREPO in "${RCONFDIR}"/*.conf; do
    NEXTRNAME="$(basename "${NEXTREPO}")"
    if [[ "layman.conf" == "${NEXTRNAME}" ]]; then
        # leave layman alone
        continue
    fi
    # assumes 1 repo per .conf file; not true for layman,
    # but we're skipping that one
    NLOCS="$(grep '^[[:space:]]*location' "${NEXTREPO}" | wc -l)"
    if ((NLOCS==0)); then
        echo "Warning: no location in repo file '${NEXTREPO}'" >&2
        continue
    elif ((NLOCS>1)); then
        echo "Warning: skipping multi-repo file '${NEXTREPO}'" >&2
        continue
    fi
    
    OLDLOC="$(grep '^[[:space:]]*location' "${NEXTREPO}" | cut -d= -f 2 | xargs | head -n 1)"
    OLDBASE="$(basename "${OLDLOC}")"
    if [[ "portage" == "${OLDBASE}" ]]; then
        NEWLOC="${NEWRDIR}/gentoo"
    else
        NEWLOC="${NEWRDIR}/${OLDBASE}"
    fi
    if [[ ! -d "${NEWLOC}" ]] && [[ -d "${OLDLOC}" ]]; then
        echo "Migrating ${OLDLOC} -> ${NEWLOC}"
        mkdir -p "${NEWRDIR}"
        mv "${OLDLOC}" "${NEWLOC}" || RC=1
        # leave symlink for safety
        ln -s "${NEWLOC}" "${OLDLOC}"
        sed -i -e "s#${OLDLOC}#${NEWLOC}#g" "${NEXTREPO}"
    fi
done
# remember to migrate the PORTDIR setting explicitly
# (for the main portage repo) in make.conf
if grep -q "^[[:space:]]*PORTDIR=" "${MC}" &>/dev/null; then
    # variable is explicitly set in make.conf, update it
    sed -i -e 's#^\s*PORTDIR=.*$#XXX-xx-XXX#g' -e "s#XXX-xx-XXX#PORTDIR=${NEWPORTDIR}#g" "${MC}"
else
    # variable not explicitly set in make.conf
    echo "PORTDIR=${NEWPORTDIR}" >> "${MC}"
fi

# correct for a migrated profile (as most likely broken by migrations above)
echo "Resetting profile symlink"
eselect profile set "${CURRPROFILE}"

if ((RC==0)); then
    echo -e "This sentinel file prevents fixup-0009 from trying to migrate\nPortage directories a second time." > "${SENTINEL}"
fi

exit $RC
