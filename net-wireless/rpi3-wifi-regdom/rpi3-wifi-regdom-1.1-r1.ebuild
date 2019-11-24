# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Service to setup WiFi regulatory domain on RPi3"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=net-wireless/iw-4.9
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_${PN}-1" "${PN}"
	newconfd "${FILESDIR}/conf.d_${PN}-1" "${PN}"
	insinto "/etc/modprobe.d"
	newins "${FILESDIR}/modprobe.d_${PN}-1" "${PN}.conf"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${PN}" default
		elog "The ${PN} service has been added to your default runlevel."
		elog "Please check /etc/conf.d/${PN}, and set an"
		elog "appropriate ISO / IEC 3166 alpha2 country code therein."
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}
