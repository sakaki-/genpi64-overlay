# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-info xdg-utils gnome2-utils autotools xfconf

DESCRIPTION="A battery monitor panel plugin for the Xfce desktop environment"
HOMEPAGE="https://goodies.xfce.org/projects/panel-plugins/xfce4-battery-plugin"
SRC_URI="https://archive.xfce.org/src/panel-plugins/${PN}/${PV%.*}/${P}.tar.bz2"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~x86 ~arm64"
IUSE="debug kernel_linux pitop"

RDEPEND=">=dev-libs/glib-2.24:2=
	>=x11-libs/gtk+-3.14:3=
	>=xfce-base/libxfce4ui-4.12:=[gtk3(+)]
	>=xfce-base/libxfce4util-4.8:=
	>=xfce-base/xfce4-panel-4.12:=
	pitop? (
		>=dev-util/xfce4-dev-tools-4.12.0
		>=xfce-base/xfconf-4.12.0-r1
		>=dev-embedded/wiringpi-2.44-r3
		|| (
			>=sys-apps/rpi3-i2cdev-1.0.0-r1
			>=sys-apps/rpi-i2c-1.0.0
		)
	)"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

REQUIRED_USE="pitop? ( ^^ ( arm arm64 ) )"

DOCS=( AUTHORS ChangeLog NEWS README )

pkg_setup() {
	XFCONF=(
		$(xfconf_use_debug)
		)
	if use kernel_linux; then
		CONFIG_CHECK="~ACPI_BATTERY"
		linux-info_pkg_setup
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

src_prepare() {
	if use pitop; then
		# patch in libpitop files and change Makefile.am to reflect deps
		epatch "${FILESDIR}"/${PV}-query-pitop-battery-over-i2c.patch
		# ensure the new deps get taken up
		einfo "Regenerating autotools files..."
		EAUTORECONF=1
	fi
	xfconf_src_prepare
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	if [[ -z ${REPLACING_VERSIONS} ]] && use pitop; then
		elog "The ${PN} has been installed."
		elog "For it to work, please be sure to enable the"
		elog "rpi3-i2cdev boot service, and to set:"
		elog "  dtparam=i2c_arm=on"
		elog "in /boot/config.txt."
	fi
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}
