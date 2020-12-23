# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6
inherit flag-o-matic toolchain-funcs git-r3

KEYWORDS="~arm ~arm64"

DESCRIPTION="Miscellaneous utilities for the Pi-Top"
HOMEPAGE="https://github.com/rricharz/pi-top-install"
SRC_URI=""
LICENSE="GPL-2+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

EGIT_REPO_URI="https://github.com/rricharz/pi-top-install"
EGIT_BRANCH="master"
# fetch the branch at the specified commit, matches ebuild date
EGIT_COMMIT="c3f35c3713c69aa06bc833dafb8b82e4e5750efd"

DEPEND=">=dev-embedded/wiringpi-2.44-r2"
RDEPEND="
        ${DEPEND}
	|| (
		>=sys-apps/rpi3-spidev-1.0.0
		>=sys-apps/rpi-spi-1.0.0
	)"

src_compile() {
        local x
        # makefile not using CFLAGS etc., but trivial to compile
        # ourselves, so let's do that
        for x in poweroff brightness; do
                rm -f "${x}" "install-${x}"
                $(tc-getCC) ${CFLAGS} ${CPPFLAGS} ${LDFLAGS} \
                        -I/usr/include/wiringpi \
                        -o "${x}" "${x}.c" \
                        -lwiringPi || die "compile ${x} failed"
        done
}

src_install() {
        newsbin poweroff pt-poweroff
        newsbin brightness pt-brightness
        DOCS=( README.md )
        einstalldocs
}

pkg_postinst() {
        if [[ -z ${REPLACING_VERSIONS} ]]; then
                elog "The (sbin) programs pt-poweroff and pt-brightness have"
                elog "been installed. These should only be used on Pi-Top"
                elog "machines. You will need SPI turned on to use them"
                elog "(set 'dtparam=spi=on' in /boot/config.txt)."
        fi
}
