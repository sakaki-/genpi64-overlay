# Copyright 2018 sakaki (sakaki@deciban.com)
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1 desktop xdg-utils

DESCRIPTION="GUI editor for /boot/config.txt on RPi3 and RPi4 SBCs"
BASE_SERVER_URI="https://github.com/GenPi64" # Required because it's available there.
HOMEPAGE="${BASE_SERVER_URI}/${PN}"
SRC_URI="${BASE_SERVER_URI}/${PN}/releases/download/v${PV}/${PN}-v${PV}.tar.gz"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~arm ~arm64"
IUSE="-systemd"

DEPEND="${PYTHON_DEPS}
	x11-apps/xhost
"

RDEPEND="${DEPEND}
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )
	>=app-shells/bash-4.0
	dev-python/PyQt5[${PYTHON_USEDEP}]
	media-libs/raspberrypi-userland
	>=net-wireless/rpi3-wifi-regdom-1.1
	sys-boot/raspberrypi-firmware
	>=sys-process/at-3.1.23
	>=x11-misc/arandr-0.1.10
	>=x11-misc/wmctrl-1.07-r2
"

SERVICENAME="rpi3-config-mv"

python_install_all() {
	distutils-r1_python_install_all

	newicon "${S}/pixmaps/gear-3d.png" pyconfig_gen.png
	make_desktop_entry "sudo pyconfig_gen" "RPi Config Tool" /usr/share/pixmaps/pyconfig_gen.png "Settings"

	newinitd "${FILESDIR}/init.d_${SERVICENAME}-1" "${SERVICENAME}"
	newconfd "${FILESDIR}/conf.d_${SERVICENAME}-1" "${SERVICENAME}"
	newbin "${FILESDIR}/rpi3-revert-config-1" "rpi3-revert-config"
	newbin "${FILESDIR}/rpi3-keep-config-2" "rpi3-keep-config"
	insinto "/etc/xdg/autostart"
	newins "${FILESDIR}/${PN}.desktop-1" "${PN}.desktop"
	dodoc README.md
	dodoc ACKNOWLEDGEMENTS
}

pkg_postinst() {
	xdg_desktop_database_update

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${SERVICENAME}" boot
		elog "The ${SERVICENAME} service has been added to your boot runlevel."
		elog "Please check /etc/conf.d/${PN} for settings."
		elog ""
		elog "Both autostart and regular .desktop files have also"
		elog "been installed."
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
}
