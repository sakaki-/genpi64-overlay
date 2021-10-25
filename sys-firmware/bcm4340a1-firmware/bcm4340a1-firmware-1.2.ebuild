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

# Had to use our own due to missing file in upstreams version.
EGIT_REPO_URI="https://github.com/GenPi64/pi-bluetooth.git"
EGIT_BRANCH="master"
EGIT_COMMIT="ff81b04b1b22235eea304268ef60653aa7922afd"

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


