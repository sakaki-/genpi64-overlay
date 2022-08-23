# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6..10} )

inherit eutils distutils-r1

MY_PN="RPi.GPIO"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="RPi.GPIO Python Module"
HOMEPAGE="https://sourceforge.net/projects/raspberry-gpio-python"
SRC_URI="https://sourceforge.net/projects/raspberry-gpio-python/files/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm arm64"
IUSE=""
RESTRICT="nomirror"

DEPEND=""

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

PATCHES=( ${FILESDIR}/${PN}-build-gcc10.patch )
