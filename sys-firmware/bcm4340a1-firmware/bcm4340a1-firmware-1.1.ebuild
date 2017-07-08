# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6
inherit git-r3

KEYWORDS="~arm ~arm64"

DESCRIPTION="Firmware for integrated bluetooth on the Raspberry Pi 3"
HOMEPAGE="https://aur.archlinux.org/packages/pi-bluetooth/"
SRC_URI=""
LICENSE="Broadcom"
SLOT="0"
IUSE=""
RESTRICT="mirror binchecks strip"

EGIT_REPO_URI="https://aur.archlinux.org/pi-bluetooth.git"
EGIT_BRANCH="master"
# following is commit for release 1-1 of the archlinux pi-bluetooth package
EGIT_COMMIT="a439f892bf549ddfefa9ba7ad1999cc515f233bf"

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	insinto "/etc/firmware"
	doins BCM43430A1.hcd
	dodoc LICENCE.broadcom_bcm43xx
}


