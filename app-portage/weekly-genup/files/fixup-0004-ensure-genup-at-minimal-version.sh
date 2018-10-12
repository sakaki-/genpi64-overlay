#!/bin/bash
#
# fixup-0004-ensure-genup-at-minimal-version.sh
#
# >=app-portage/genup-1.0.18 checks for new versions of itself very
# early in the update process, switching over to the new version if
# found. This provides a convenient mechanism to address problems in
# e.g., the main @world emerge stage, which may otherwise cause the
# system to become deadlocked; but RPi3s running earlier versions
# of genup cannot be helped out by this feature, if already in a
# situation where the @world update will not run.
#
# Accordingly, this fixup script simply checks if genup is installed
# and, if so, whether its version is >=1.0.18; if <, it attempts to
# update it (the cost of doing so is small, since genup, being a
# script, requires no compilation etc.)
#
# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

MIN_GENUP_VERSION="1.0.18"
GENUP="/usr/sbin/genup"
GENUP_PKG="app-portage/genup"

# returns 0 if first arg (version string) >= second arg, 1 otherwise
vergte() {
    [[ "${2}" == "$(echo -e "${1}\n${2}" | sort --version-sort | head -n 1)" ]]
}

echo "Checking genup (if installed) meets minimum requirements"
if [[ -x "${GENUP}" ]]; then
    if ! vergte "$("${GENUP}" --version)" "${MIN_GENUP_VERSION}"; then
        echo "genup is installed, but reports version < ${MIN_GENUP_VERSION}"
        echo "(which is the minimum recommended); attempting to upgrade"
        # following is a lightweight process and will be carried out
        # once per week at most
        emerge --verbose --oneshot --update "${GENUP_PKG}"
    fi
fi
