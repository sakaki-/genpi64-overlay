# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm arm64"

DESCRIPTION="Startup script to enable on-demand CPU frequency scaling on RPi3"
HOMEPAGE="https://github.com/GenPi64/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="-systemd"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	systemd?  ( >=sys-apps/systemd-242-r6 )
	!systemd? ( >=sys-apps/openrc-0.41 )
	>=app-shells/bash-4.0"

src_install() {
	newinitd "${FILESDIR}/init.d_rpi3-ondemand-2" "rpi3-ondemand"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} || ${REPLACING_VERSIONS} < 1.1.0 ]]; then
		elog "Please run:"
		elog "  rc-update add rpi3-ondemand sysinit"
		elog "to enable on-demand CPU frequency scaling"
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}

