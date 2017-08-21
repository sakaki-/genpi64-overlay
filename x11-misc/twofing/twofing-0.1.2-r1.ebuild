# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6
inherit udev

KEYWORDS="~amd64 ~arm ~arm64"

DESCRIPTION="Daemon converting touchscreen two-finger gestures to mouse events"
HOMEPAGE="http://plippo.de/p/${PN}"
SRC_URI="http://plippo.de/dwl/${PN}/${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE=""
RESTRICT="mirror"

DEPEND=">=x11-libs/libXtst-1.2.3
	>=x11-libs/libXrandr-1.5.1
	>=x11-libs/libX11-1.6.5
	>=x11-libs/libXi-1.7.9
	>=x11-misc/xdg-user-dirs-0.15
	virtual/udev
	"
RDEPEND="${DEPEND}"

src_prepare() {
	# correct install path for udev rules
	sed -e "s:/etc/udev/rules.d/:/lib/udev/rules.d/:" -i Makefile
	default
}

src_install() {
	default

	# add any custom udev rules in the files subdirectory
	local nextrule
	shopt -s nullglob
	for nextrule in "${FILESDIR}"/*.rules; do
		udev_dorules "${nextrule}"
	done
	shopt -u nullglob

	# add autostart rule for the daemon
	insinto "/etc/xdg/autostart/"
	newins "${FILESDIR}/${PN}.desktop-1" "${PN}.desktop"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The ${PN} daemon has been installed."
		elog "Reboot (and log in graphically) to start using it."
		elog "Only a small number of touchscreens are currently"
		elog "recognized automatically."
	fi
}
