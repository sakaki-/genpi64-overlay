# Copyright (c) 2017-19 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Configuration file required for integrated WiFi on RPi3/4"
HOMEPAGE="https://github.com/RPi-Distro/firmware-nonfree"
SRC_URI=""
LICENSE="Broadcom"
SLOT="0"
IUSE="43455-fix"
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-kernel/linux-firmware-20190726-r2[43455-fix(-)?]"

# We just bundle the config in files/, since otherwise we'd have to download
# the whole firmware git archive to install...
src_install() {
	insinto "/lib/firmware/brcm"
	newins "${FILESDIR}/brcmfmac43430-sdio.txt-20190812" brcmfmac43430-sdio.txt
	newins "${FILESDIR}/brcmfmac43430-sdio.raspberrypi-rpi.txt-20190812" brcmfmac43430-sdio.raspberrypi-rpi.txt
	newins "${FILESDIR}/brcmfmac43455-sdio.txt-${PV}" brcmfmac43455-sdio.txt
	newins "${FILESDIR}/brcmfmac43455-sdio.clm_blob-20190812" brcmfmac43455-sdio.clm_blob
	if use 43455-fix; then
		newins "${FILESDIR}/brcmfmac43455-sdio.bin-${PV}" brcmfmac43455-sdio.bin
	fi
}
