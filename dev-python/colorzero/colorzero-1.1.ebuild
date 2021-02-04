# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6..9} )

inherit distutils-r1

MY_PN="${PN}-release"
DESCRIPTION="Colorzero is a color manipulation library for Python"
HOMEPAGE="https://colorzero.readthedocs.io/"
SRC_URI="https://github.com/waveform80/${PN}/archive/release-1.1.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~arm64"
IUSE=""
RESTRICT="nomirror"

DEPEND=""

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${PV}"
