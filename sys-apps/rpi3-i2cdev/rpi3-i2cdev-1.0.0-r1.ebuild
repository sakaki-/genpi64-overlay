# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Service and udev rule for I2C device access on the Raspberry Pi 3"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=sys-apps/openrc-0.21
	>=virtual/udev-215
	>=app-shells/bash-4.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/60-i2c-wheel-group-access.rules"
	newinitd "${FILESDIR}/init.d_${PN}-1" "${PN}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Please run:"
		elog "  rc-update add ${PN} boot"
		elog "to enable the ${PN} service, and also ensure"
		elog "  dtparam=i2c_arm=on"
		elog "is set in /boot/config.txt, to use the I2C interface."
	fi
}
