EAPI=6
inherit git-r3

KEYWORDS="arm arm64"

DESCRIPTION="Service and udev rule for integrated bluetooth on the Raspberry Pi 3"
HOMEPAGE="https://aur.archlinux.org/packages/pi-bluetooth/"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd"
RESTRICT="mirror"

# Had to use our own due to missing file in upstreams version.
EGIT_REPO_URI="https://github.com/GenPi64/pi-bluetooth.git"
EGIT_BRANCH="master"
EGIT_COMMIT="ff81b04b1b22235eea304268ef60653aa7922afd"

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
