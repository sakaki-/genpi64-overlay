# Copyright 2019 sakaki (sakaki@deciban.com)
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop xdg-utils

DESCRIPTION="GUI to live view camera output on RPi3/4 SBCs"
BASE_SERVER_URI="https://github.com/GenPi64"
HOMEPAGE="${BASE_SERVER_URI}/${PN}"
SRC_URI="${BASE_SERVER_URI}/${PN}/releases/download/${PV}/${P}.tar.gz"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND="
	>=xfce-base/xfce4-meta-4.12
"

RDEPEND="${DEPEND}
	>=app-admin/sudo-1.8.27-r1
	>=app-shells/bash-4.0
	>=gnome-extra/zenity-3.28.1
	>=media-video/ffmpeg-4.1.1-r2[sdl,v4l]
	>=media-libs/raspberrypi-userland-1.20190114
"

src_install() {
	doicon "${S}/${PN}.png"
	make_desktop_entry "${PN}" "RPi Camera Live View" /usr/share/pixmaps/"${PN}".png "AudioVideo"
	dobin "${S}/${PN}"
	dodoc README.md
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
