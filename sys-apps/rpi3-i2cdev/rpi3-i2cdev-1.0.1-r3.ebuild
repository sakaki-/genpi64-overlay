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
IUSE="-systemd"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )
	>=virtual/udev-215
	>=app-shells/bash-4.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/60-i2c-wheel-group-access.rules"
	newinitd "${FILESDIR}/init.d_${PN}-4" "${PN}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		if ! grep -q "^\s*${PN}\s" <(rc-update show boot) &>/dev/null; then
			rc-update add "${PN}" boot
			elog "The ${PN} service has been added to your boot runlevel."
			elog "To activate, and use the I2C interface, please set:"
			elog "  dtparam=i2c_arm=on"
			elog "in /boot/config.txt, and reboot."
		fi
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}
