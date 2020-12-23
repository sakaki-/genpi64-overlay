# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Raspberry PI boot loader, firmware, and configs, for 64-bit mode"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 raspberrypi-videocore-bin Broadcom"
SLOT="0"
KEYWORDS="~arm64"
IUSE="pitop +dtbo"
RESTRICT="mirror binchecks strip"

DEPEND=""
RDEPEND="
	!sys-boot/raspberrypi-firmware
	${DEPEND}"

S="${WORKDIR}/firmware-${PV}"

pkg_preinst() {
	if ! grep "${ROOT%/}/boot" /proc/mounts >/dev/null 2>&1; then
		ewarn "${ROOT%/}/boot is not mounted, the files might not be installed at the right place"
	fi
}

src_install() {
	cd boot
	insinto /boot
	doins *.elf
	# allow for the dtbos to be provided by the kernel package
	if use dtbo; then
		doins -r overlays
	fi
	doins *.bin
	doins *.dat
	doins *.broadcom
	# 'starter' versions of these files, will be CONFIG_PROTECTed
	if use pitop; then
		newins "${FILESDIR}/config.pitop.txt-2" config.txt
	else
		newins "${FILESDIR}/config.txt-2" config.txt
	fi
	newins "${FILESDIR}/cmdline.txt-2" cmdline.txt
	newenvd "${FILESDIR}"/config_protect-1 99${PN}
	# assume kernel and dtbs are provided separately
	# e.g. by sys-kernel/bcmrpi3-kernel-bin package
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
