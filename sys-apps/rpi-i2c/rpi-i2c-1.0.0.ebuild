# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Service and udev rule to allow i2c group RPi I2C access"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

ACCT_DEPEND="
	acct-group/i2c
"
DEPEND="
	${ACCT_DEPEND}
	>=sys-apps/openrc-0.21
	>=virtual/udev-215
	>=app-shells/bash-4.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-i2c-group-access.rules"
	newinitd "${FILESDIR}/init.d_${PN}-1" "${PN}"
}

add_wheel_members_to_i2c_group() {
	local nextuser
	for nextuser in $(grep "^wheel:" /etc/group | cut -d: -f4 | tr "," " "); do
		usermod -a -G i2c ${nextuser}
	done
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Adding all members of wheel to the i2c group"
		add_wheel_members_to_i2c_group
		if ! grep -q "^\s*${PN}\s" <(rc-update show boot) &>/dev/null; then
			rc-update add "${PN}" boot
			elog "The ${PN} service has been added to your boot runlevel."
			elog "To activate, and use the I2C interface, please set:"
			elog "  dtparam=i2c_arm=on"
			elog "in /boot/config.txt, and reboot."
		fi
	fi
}
