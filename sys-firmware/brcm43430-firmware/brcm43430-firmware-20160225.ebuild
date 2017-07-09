# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm ~arm64"

DESCRIPTION="Configuration file required for integrated WiFi on RPi3"
HOMEPAGE="https://github.com/RPi-Distro/firmware-nonfree"
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

# We just bundle the config in files/, since otherwise we'd have to download
# the whole firmware git archive to install...
src_install() {
	insinto "/lib/firmware/brcm"
	newins "${FILESDIR}/brcmfmac43430-sdio.txt-${PV}" brcmfmac43430-sdio.txt
}
