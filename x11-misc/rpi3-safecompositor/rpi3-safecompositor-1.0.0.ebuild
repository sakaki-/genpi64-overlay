# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm64"

DESCRIPTION="Turn off display compositing for high RPi3 pixel clock values"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=media-libs/raspberrypi-userland-1.20170721-r1
	>=sys-apps/openrc-0.21
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_${PN}-1" "${PN}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${PN}" default
		elog "The ${PN} service has been added to your default runlevel."
	fi
}
