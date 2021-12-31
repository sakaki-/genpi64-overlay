# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=5

KEYWORDS="~arm arm64"

DESCRIPTION="Misc init scripts for the gentoo-on-rpi3-64bit image"
HOMEPAGE="https://github.com/GenPi64/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd +X"
RESTRICT="mirror"
AR_SVCNAME="autoexpand-root"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	rpi-onetime-startup
	X? ( >=x11-apps/xdm-1.1.12 )
	systemd?  ( >=sys-apps/systemd-246.6 )
	!systemd? ( >=sys-apps/openrc-0.42.1-r1 )
	>=app-shells/bash-5.1_p4"

src_install() {
	newinitd "${FILESDIR}/init.d_autoexpand_root-5" "${AR_SVCNAME}"
	insinto "/usr/share/X11/xorg.conf.d"
	newins "${FILESDIR}/50-disable-Xv.conf-1" "50-disable-Xv.conf"
	insinto "/etc/NetworkManager/conf.d"
	newins "${FILESDIR}/50-hostname-mode-none.conf-1" "50-hostname-mode-none.conf"
	insinto "/etc/sysctl.d"
	newins "${FILESDIR}/35-low-memory-cache-settings.conf-1" "35-low-memory-cache-settings.conf"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${AR_SVCNAME}" boot
		elog "The first-boot root partition resizing service has been activated."
		elog "This service will run so long as the sentinel file /boot/dont_autoexpand_root"
		elog "Does not exist."
		elog "To disable entirely, run:"
		elog "  rc-update del ${AR_SVCNAME} boot"
	fi
	local OLDRULE="/etc/X11/xorg.conf.d/50-disable-Xv.conf"
	if [ -f "${OLDRULE}" ]; then
		elog "Removing old XVideo disable rule"
		elog "New managed version is in /usr/share/X11/xorg.conf.d"
		rm "${OLDRULE}"
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}
