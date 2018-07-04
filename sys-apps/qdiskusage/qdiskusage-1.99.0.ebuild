# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

inherit versionator

DESCRIPTION="Qt4 Graphical Disk Usage Analyzer"
HOMEPAGE="http://www.qt-apps.org/content/show.php/QDiskUsage?content=107012"
SRC_URI=""

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND=""
DEPEND="${RDEPEND}"

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] || [[ ${REPLACING_VERSIONS} < 1.99 ]]; then
		elog "The 'real' qdiskusage package has been treecleaned, and"
		elog "since the current version requires Qt4, the overlay package"
		elog "has now been replaced with this dummy package (to prevent"
		elog "autoupdate blocks)."
		elog "Feel free to unmerge this package from your @world set."
	fi
}
