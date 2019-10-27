# Copyright (c) 2019 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=7
inherit unpacker

DESCRIPTION="RPi4 VLI (USB) and bootloader EEPROM updater"
HOMEPAGE="https://github.com/raspberrypi/rpi-eeprom/"
MY_PN="rpi-eeprom"
SRC_URI="http://archive.raspberrypi.org/debian/pool/main/r/rpi-eeprom/${MY_PN}_$(ver_rs 2 '-')_all.deb"
SLOT="0"
LICENCE="BSD rpi-bootloader"
RESTRICT="mirror"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND="
	>=app-shells/bash-4.0"
RDEPEND="
	${DEPEND}
	~dev-embedded/rpi4-eeprom-images-${PV}
	>=sys-apps/flashrom-1.0
	>=media-libs/raspberrypi-userland-1.20190808"

QA_PREBUILT="usr/bin/vl805"
QA_PRESTRIPPED="${QA_PREBUILT}"

S="${WORKDIR}"

src_unpack() {
	unpack_deb "${A}"
	cd "${WORKDIR}/usr/share/doc/${MY_PN}" && unpack ./changelog.Debian.gz && rm -f ./changelog.Debian.gz
	cd "${WORKDIR}/usr/share/man/man1" && unpack ./*.1.gz && rm -f ./*.1.gz
}

src_install() {
	keepdir /var/lib/raspberrypi/bootloader/backup
	dodoc -r usr/share/doc/${MY_PN}/*
	doman usr/share/man/man1/*.1
	dobin usr/bin/*
	insinto /etc/default
	doins etc/default/*
	newinitd "${FILESDIR}/init.d_${PN}-1" "${PN}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		rc-update add "${PN}" default
		elog "The ${PN} service has been added to your default runlevel."
		elog "Please check /etc/default/rpi-eeprom-update for settings."
	fi
}
