# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

#MY_PV="1.7.3"

CMAKE_MAKEFILE_GENERATOR="emake"
CMAKE_IN_SOURCE_BUILD=1

DESCRIPTION="Raspberry Pi Imager (WIP ebuild)"
HOMEPAGE="https://github.com/raspberrypi/rpi-imager"
SRC_URI="https://github.com/raspberrypi/rpi-imager/archive/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${P}/src"

LICENSE="Apache"
SLOT="0"
KEYWORDS="~arm64 ~amd64"
IUSE=""

DEPEND="
        dev-qt/qtconcurrent
        "

RDEPEND="
        dev-qt/qtquickcontrols2
        "
