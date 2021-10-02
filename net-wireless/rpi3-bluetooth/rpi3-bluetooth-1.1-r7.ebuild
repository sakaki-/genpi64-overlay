# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6
inherit git-r3

KEYWORDS="~arm arm64"

DESCRIPTION="Service and udev rule for integrated bluetooth on the Raspberry Pi 3"
HOMEPAGE="https://aur.archlinux.org/packages/pi-bluetooth/"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd"
RESTRICT="mirror"

EGIT_REPO_URI="https://aur.archlinux.org/pi-bluetooth.git"
EGIT_BRANCH="master"
# following is commit for release 1-1 of the archlinux pi-bluetooth package
EGIT_COMMIT="a439f892bf549ddfefa9ba7ad1999cc515f233bf"

DEPEND=""
RDEPEND="
	${DEPEND}
	~sys-firmware/bcm4340a1-firmware-${PV}
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )
	|| (	~net-wireless/bluez-5.43
		>=net-wireless/bluez-5.44[deprecated] )
	>=virtual/udev-215
	>=app-shells/bash-4.0"

src_prepare() {
	sed -i -e "s#/bin#/usr/bin#g" 50-bluetooth-hci-auto-poweron.rules
	default
}

src_install() {
	insinto "/lib/udev/rules.d"
	doins 50-bluetooth-hci-auto-poweron.rules
	newinitd "${FILESDIR}/init.d_${PN}-5" "${PN}"
	newsbin "${FILESDIR}/rpi3-attach-bluetooth-3" "rpi3-attach-bluetooth"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Please run:"
		elog "  rc-update add ${PN} default"
		elog "to enable the ${PN} service"
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}
