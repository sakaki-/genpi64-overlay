# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6
inherit systemd

KEYWORDS="~arm64"

DESCRIPTION="Turn off display compositing for high RPi3 pixel clock values"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="systemd"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-apps/ethtool-4.16
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_${PN}-2" "${PN}"
	systemd_dounit "${FILESDIR}/1.0.1/rpi3-ethfix.service"

	dodir "/usr/lib/rpi-scripts/bin"
	into "/usr/lib/rpi-scripts"
	dobin "${FILESDIR}/1.0.1/rpi3-ethfix"
}

pkg_postinst() {
	if use systemd; then
		systemctl daemon-reload
		systemctl enable "${PN}.service"
	else
		rc-update add "${PN}" default	
	fi
	elog "The ${PN} service has been added to your default runlevel."
}
