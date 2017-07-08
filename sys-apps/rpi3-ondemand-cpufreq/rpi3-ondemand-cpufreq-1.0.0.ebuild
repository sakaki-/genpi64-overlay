# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Startup script to enable on-demand CPU frequency scaling on RPi3"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-apps/openrc-0.21
	>=app-shells/bash-4.0"

src_install() {
	exeinto "/etc/local.d"
	newexe "${FILESDIR}/ondemand_freq_scaling.start-1" "ondemand_freq_scaling.start"
}

pkg_postinst() {
	elog "On-demand CPU frequency scaling will be enabled on startup."
}

