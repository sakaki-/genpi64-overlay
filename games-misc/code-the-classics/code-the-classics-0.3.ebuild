# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit unpacker xdg-utils

DESCRIPTION="Python games to accompany Code the Classics Volume 1 book"
HOMEPAGE="https://wireframe.raspberrypi.org/books/code-the-classics1"
SRC_URI="http://archive.raspberrypi.org/debian/pool/main/c/${PN}/${PN}_${PV}_all.deb"

LICENSE="BSD-2-Clause"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~arm64"
IUSE=""
RESTRICT="nomirror"

DEPEND="
	dev-python/pgzero
"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	cp -a ${S}/* ${D}
}

pkg_postinst() {
	xdg_desktop_database_update
}
