# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2
# NO WARRANTY

EAPI=5

KEYWORDS="~arm64"

DESCRIPTION="Post-sync signed hash check for isshoni.org rsync gentoo repo"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=">=sys-apps/portage-2.3.0"
RDEPEND="${DEPEND}
	>=app-shells/bash-4.2
	>=app-portage/porthash-1.0.3[add-pubkey]"

src_install() {
	exeinto "/etc/portage/repo.postsync.d"
	newexe "${FILESDIR}/${PN}-1" "${PN}"
}

pkg_postinst() {
	elog "A new post-sync hook has been installed to"
	elog "/etc/portage/repo.postsync.d/${PN}"
	elog "This will validate the main gentoo repo, iff it is updated by"
	elog "rsync from rsync://isshoni.org/gentoo-portage-pi64, using the"
	elog "provided signed master checksum."
	elog "If this causes trouble on your system, simply make this"
	elog "file non-executable, or uninstall this package."
}
