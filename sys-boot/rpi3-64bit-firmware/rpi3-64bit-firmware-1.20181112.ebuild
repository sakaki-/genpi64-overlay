# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Raspberry PI boot loader and firmware, for 64-bit mode"
HOMEPAGE="https://github.com/raspberrypi/firmware"
SRC_URI="https://github.com/raspberrypi/firmware/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 raspberrypi-videocore-bin Broadcom"
SLOT="0"
KEYWORDS="~arm64"
IUSE="pitop"
RESTRICT="mirror binchecks strip"

DEPEND=""
RDEPEND="
	>=sys-boot/rpi3-boot-config-1.0.0[pitop(-)?]
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
	doins -r overlays
	doins *.bin
	doins *.dat
	doins *.broadcom
	# assume /boot/cmdline.txt and /boot/config.txt now
	# provided by rpi3-boot-config package;
	# assume kernel and dtbs are provided separately
	# e.g. by sys-kernel/bcmrpi3-kernel-bin package
}
