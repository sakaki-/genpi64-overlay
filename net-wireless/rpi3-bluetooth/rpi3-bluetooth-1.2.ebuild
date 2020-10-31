# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6
inherit git-r3 systemd

KEYWORDS="~arm ~arm64"

DESCRIPTION="Service and udev rule for integrated bluetooth on the Raspberry Pi 3"
HOMEPAGE="https://aur.archlinux.org/packages/pi-bluetooth/"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="systemd"
RESTRICT="mirror"

EGIT_REPO_URI="https://aur.archlinux.org/pi-bluetooth.git"
EGIT_BRANCH="master"
# following is commit for release 1-1 of the archlinux pi-bluetooth package
EGIT_COMMIT="a439f892bf549ddfefa9ba7ad1999cc515f233bf"

DEPEND=""
RDEPEND="
	${DEPEND}
	~sys-firmware/bcm4340a1-firmware-1.1
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
	systemd_dounit "${FILESDIR}/1.2/rpi3-bluetooth.service"
	newsbin "${FILESDIR}/rpi3-attach-bluetooth-3" "rpi3-attach-bluetooth"

	dodir "/usr/lib/rpi-scripts/bin"
	into "/usr/lib/rpi-scripts"
	dobin "${FILESDIR}/1.2/rpi3-bluetooth"
}

pkg_postinst() {
	elog "To start the service and enable on bootup"
	if use systemd; then
		elog "  systemctl daemon-reload"
		elog "  systemctl start ${PN}.service"
		elog "  systemctl enable ${PN}.service"
	else
		elog "  /etc/init.d/${PN} start "
		elog "  rc-update add ${PN} sysinit "
	fi
}
