# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Ensure Pi-Top's hub powered off correctly on shutdown"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND="
	>=dev-embedded/pitop-utils-1.20170723-r1
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )"
DEPEND="${RDEPEND}"

src_install() {
	newinitd "${FILESDIR}/init.d_${PN}-5" "${PN}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The ${PN} service has been installed."
		elog "This should only be used on Pi-Top machines."
		elog "To activate it, issue:"
		elog "  rc-update add ${PN} shutdown"
		elog ""
		elog "You will also need SPI turned on"
                elog "(set 'dtparam=spi=on' in /boot/config.txt)."
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}

