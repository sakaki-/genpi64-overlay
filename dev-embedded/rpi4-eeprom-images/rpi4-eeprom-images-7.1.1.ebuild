# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=7
inherit unpacker

DESCRIPTION="RPi4 VLI (USB) and bootloader EEPROM images"
HOMEPAGE="https://github.com/raspberrypi/rpi-eeprom/"
MY_PN="rpi-eeprom-images"
SRC_URI="http://archive.raspberrypi.org/debian/pool/main/r/rpi-eeprom/${MY_PN}_$(ver_rs 2 '-')_all.deb"
SLOT="0"
LICENCE="BSD rpi-bootloader"
RESTRICT="mirror"
KEYWORDS="~arm ~arm64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
	cd "${WORKDIR}/usr/share/doc/${MY_PN}" && unpack ./changelog.Debian.gz && rm -f ./changelog.Debian.gz
}

src_install() {
	insinto /
	doins -r lib
	dodoc -r usr/share/doc/${MY_PN}/*
}
