# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Prevent xscreensaver blanking display when notionally off"
HOMEPAGE="https://github.com/GenPi64/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=xfce-base/xfce4-meta-4.12
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )"
RDEPEND="${DEPEND}
	>=app-shells/bash-4.4_p23
	>=app-admin/sudo-1.8.26
	>=x11-apps/xset-1.2.4
	>=x11-misc/xscreensaver-5.40"

src_install() {
	newbin "${FILESDIR}/${PN}-2" "${PN}"
	insinto "/etc/xdg/autostart/"
	newins "${FILESDIR}/${PN}.desktop-1" "${PN}.desktop"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "A simple Xfce startup script to disable"
		elog "xscreensaver blanking has been installed."
		elog "This will take effect for each user from their"
		elog "next graphical login."
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}
