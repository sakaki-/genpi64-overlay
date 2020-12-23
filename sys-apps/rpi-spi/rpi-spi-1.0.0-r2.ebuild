# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="udev rule to allow spi group RPi SPI access"
HOMEPAGE="https://github.com/GenPi64/gentoo-on-rpi-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

ACCT_DEPEND="
	acct-group/spi
"
DEPEND="
	${ACCT_DEPEND}
	!sys-apps/rpi3-spidev
	>=virtual/udev-215
	>=app-shells/bash-4.0"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/lib/udev/rules.d"
	doins "${FILESDIR}/99-spi-group-access.rules"
}

add_wheel_members_to_spi_group() {
	local nextuser
	for nextuser in $(grep "^wheel:" /etc/group | cut -d: -f4 | tr "," " "); do
		usermod -a -G spi ${nextuser}
	done
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] ; then
		elog "Adding all members of wheel to the spi group"
		add_wheel_members_to_spi_group
		elog "To use the SPI interface, please ensure:"
		elog "  dtparam=spi=on"
		elog "is set in /boot/config.txt."
	fi
}
