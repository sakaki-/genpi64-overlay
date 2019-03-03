# Copyright 2018 sakaki (sakaki@deciban.com)
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{3_5,3_6} )

inherit distutils-r1 desktop xdg-utils

DESCRIPTION="GUI editor for /boot/config.txt on RPi3 SBCs"
BASE_SERVER_URI="https://github.com/sakaki-"
HOMEPAGE="${BASE_SERVER_URI}/${PN}"
SRC_URI="${BASE_SERVER_URI}/${PN}/releases/download/v${PV}/${PN}-v${PV}.tar.gz"

RESTRICT="mirror"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND="${PYTHON_DEPS}
	>=xfce-base/xfce4-meta-4.12
"

RDEPEND="${DEPEND}
	>=sys-apps/openrc-0.21
	>=app-shells/bash-4.0
	dev-python/PyQt5[${PYTHON_USEDEP}]
	>=media-libs/raspberrypi-userland-1.20170721-r1
	>=sys-process/at-3.1.23
"

SERVICENAME="rpi3-config-mv"

python_install_all() {
	distutils-r1_python_install_all

	newicon "${S}/pixmaps/gear-3d.png" pyconfig_gen.png
	make_desktop_entry "sudo pyconfig_gen" "RPi3 Config Tool" /usr/share/pixmaps/pyconfig_gen.png "Settings"

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
}

pkg_postrm() {
	xdg_desktop_database_update
}
