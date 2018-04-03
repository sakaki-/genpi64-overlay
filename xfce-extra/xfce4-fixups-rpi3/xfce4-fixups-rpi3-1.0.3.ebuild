# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Xfce4 new-user fixups for RPi3 (compositing etc.)"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=xfce-base/xfce4-meta-4.12
	>=sys-apps/openrc-0.21"
RDEPEND="${DEPEND}
	>=app-shells/bash-4.0"

src_install() {
	newbin "${FILESDIR}/${PN}-4" "${PN}"
	insinto "/etc/xdg/autostart/"
	newins "${FILESDIR}/${PN}.desktop-1" "${PN}.desktop" 
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Some simple per-user Xfce fixups have been installed."
		elog "These will take effect for each user from their"
		elog "next graphical login, and will only be applied once."
	fi
}
