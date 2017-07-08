# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=5

KEYWORDS="~arm64"

DESCRIPTION="Misc init scripts for the RPi3 (running in 64-bit mode)"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=x11-apps/xdm-1.1.11-r3
	>=sys-apps/openrc-0.21
	>=app-shells/bash-4.0"

src_install() {
	exeinto "/etc/local.d"
	newexe "${FILESDIR}/autoexpand_root_partition.start-1" "autoexpand_root_partition.start"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "To enable the first-boot root partition resizing service"
		elog "(which also force-sets the root and demouser passwords, and"
		elog "starts an Xfce session for demouser), then create (touch)"
		elog "the sentinel file /boot/autoexpand_root_partition."
		elog "To do the same (but skipping the autoexpand step) create"
		elog "(touch) the file /boot/autoexpand_root_none instead."
	fi
}

