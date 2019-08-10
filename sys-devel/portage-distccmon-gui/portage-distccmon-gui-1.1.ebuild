# Copyright (c) 2016-7 sakaki <sakaki@deciban.com>
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils

DESCRIPTION="Desktop file (and wrapper) to view Portage jobs with distccmon-gui"
HOMEPAGE=""

SRC_URI=""

RESTRICT="mirror"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~arm64"

RDEPEND="
	x11-libs/gtk+:2
	>=sys-devel/distcc-3.1
"

DEPEND="${RDEPEND}"

# Required by Portage, as we have no SRC_URI
S="${WORKDIR}"

src_install() {
	exeinto /usr/bin
	doexe "${FILESDIR}/${PN}.sh"
	insinto /usr/share/applications
	newins "${FILESDIR}/${PN}.desktop-1" "${PN}.desktop"
}

pkg_postinst() {
	elog "You need to be a member of the portage group to see output as a normal."
	elog "user."
}
