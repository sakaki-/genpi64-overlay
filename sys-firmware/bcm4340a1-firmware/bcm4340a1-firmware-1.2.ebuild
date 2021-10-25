EAPI=6
inherit git-r3

KEYWORDS="arm arm64"

DESCRIPTION="Firmware for integrated bluetooth on the Raspberry Pi 3"
HOMEPAGE="https://aur.archlinux.org/packages/pi-bluetooth/"
SRC_URI=""
LICENSE="Broadcom"
SLOT="0"
IUSE=""
RESTRICT="mirror binchecks strip"

EGIT_REPO_URI="https://aur.archlinux.org/pi-bluetooth.git"
EGIT_BRANCH="master"
# following is commit for release 1-2_3 of the archlinux pi-bluetooth package
EGIT_COMMIT="039cc1628501980885d4b6a0d4bd2dcab120096d"

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
   wget https://raw.githubusercontent.com/RPi-Distro/bluez-firmware/8445a53ce2c51a77472b908a0c8f6f8e1fa5c37a/broadcom/BCM43430A1.hcd
   eapply_user
}

src_install() {
	insinto "/etc/firmware"
	doins BCM43430A1.hcd
	dodoc LICENCE.broadcom_bcm43xx
}


