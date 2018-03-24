# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Configuration file required for integrated WiFi on RPi3 B+"
HOMEPAGE="https://www.raspberrypi.org/downloads/raspbian/"
SRC_URI=""
LICENSE="Broadcom"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-kernel/linux-firmware-20170113"

# We just bundle the config in files/, since it's a simple text file
# (copied from the Raspbian release of the same date)
src_install() {
	insinto "/lib/firmware/brcm"
	newins "${FILESDIR}/brcmfmac43455-sdio.txt-${PV}" brcmfmac43455-sdio.txt
}
