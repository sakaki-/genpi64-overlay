# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=7
inherit systemd

KEYWORDS="~arm ~arm64"

DESCRIPTION="Startup script to enable on-demand CPU frequency scaling on RPi3"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE="systemd"
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
	systemd_dounit "${FILESDIR}/rpi3-ondemand-cpufreq.service"
	dodir "/usr/lib/rpi-scripts/bin"
	into "/usr/lib/rpi-scripts"
	dobin "${FILESDIR}/rpi3-ondemand"
}

pkg_postinst() {
	elog "To start the service and enable on bootup"
	if use systemd; then
		elog "  systemctl daemon-reload"
        elog "  systemctl start rpi3-ondemand-cpufreq.service"
		elog "  systemctl enable rpi3-ondemand-cpufreq.service"
	else
		elog "  /etc/init.d/rpi3-ondemand start "
		elog "  rc-update add rpi3-ondemand sysinit "
	fi
	elog "to enable on-demand CPU frequency scaling"
}
