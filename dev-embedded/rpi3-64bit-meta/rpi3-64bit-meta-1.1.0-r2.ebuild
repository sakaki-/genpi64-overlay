# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Baseline packages for the gentoo-on-rpi3-64bit image"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+boot-fw +kernel-bin +porthash +weekly-genup"

RDEPEND="
	kernel-bin? (
		boot-fw? (
			>=sys-kernel/bcmrpi3-kernel-bin-4.9.30.20170601[with-matching-boot-fw(-)]
		)
		!boot-fw? (
			>=sys-kernel/bcmrpi3-kernel-bin-4.9.30.20170601[-with-matching-boot-fw(-)]
		)
	)
	!kernel-bin? (
		boot-fw? (
			>=sys-boot/rpi3-64bit-firmware-1.20161215
		)
		!boot-fw? (
			!sys-boot/rpi3-64bit-firmware
		)
	)
	>=sys-apps/rpi3-ondemand-cpufreq-1.0.0
	>=sys-apps/rpi3-init-scripts-1.1.1
	>=net-wireless/rpi3-bluetooth-1.1-r1
	>=sys-firmware/brcm43430-firmware-20160225
	porthash? ( >=app-portage/rpi3-check-porthash-1.0.0 )
	weekly-genup? ( >=app-portage/weekly-genup-1.0.0 )
	!weekly-genup? ( !app-portage/weekly-genup )
"

