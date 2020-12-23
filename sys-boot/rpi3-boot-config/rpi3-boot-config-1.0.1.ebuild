# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Raspberry PI {config,cmdline}.txt, for 64-bit mode"
HOMEPAGE="https://www.raspberrypi.org/documentation/configuration/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"
IUSE="pitop"
RESTRICT="mirror"

DEPEND=""
RDEPEND="
	${DEPEND}"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

pkg_preinst() {
	if ! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1; then
		ewarn "${ROOT%/}/boot is not mounted, the files might not be installed at the right place"
	fi
}

src_install() {
	insinto /boot
	# 'starter' versions of these files, will be CONFIG_PROTECTed
	if use pitop; then
		newins "${FILESDIR}/config.pitop.txt-2" config.txt
	else
		newins "${FILESDIR}/config.txt-2" config.txt
	fi
	newins "${FILESDIR}/cmdline.txt-1" cmdline.txt
	newenvd "${FILESDIR}"/config_protect-1 99${PN}
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "Starter versions of /boot/config.txt and /boot/cmdline.txt"
		elog "have been installed. Modify them as required."
		elog "See e.g.:"
		elog "  https://www.raspberrypi.org/documentation/configuration/cmdline-txt.md"
		elog "  https://www.raspberrypi.org/documentation/configuration/config-txt/README.md"
	fi
}
