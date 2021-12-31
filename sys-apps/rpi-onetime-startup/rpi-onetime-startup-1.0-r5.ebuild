# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY
EAPI=6

inherit systemd

KEYWORDS="~arm arm64"

DESCRIPTION="Run one-time startup script, if present"
HOMEPAGE="https://github.com/GenPi64/gentoo-on-rpi-64bit"
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
	newinitd "${FILESDIR}/init.d_${PN}-2" "${PN}"
	exeinto /boot
	newexe "${FILESDIR}/startup.sh-2" "startup.sh"
	newenvd "${FILESDIR}"/config_protect-1 99${PN}
	newexe "${FILESDIR}/autoexpand_root.sh-5" "autoexpand_root.sh"
	systemd_newunit "${FILESDIR}/autoexpand_root.service-5" "autoexpand_root.service"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${PN}" default
		elog "The ${PN} service has been added to your default runlevel."
	fi
	if use systemd; then
		ewarn "You are running with the systemd USE flag set!"
		ewarn "However, this package does not yet formally support systemd, so"
		ewarn "you are on your own to get things working ><"
	fi
}
