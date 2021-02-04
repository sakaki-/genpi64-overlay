# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

PYTHON_COMPAT=( python3_{6..9} )

inherit eutils distutils-r1

MY_PV="${PV}.post5"

DESCRIPTION="A zero-boilerplate games programming framework for Python 3, based on Pygame."
HOMEPAGE="https://pygame-zero.readthedocs.io/"
SRC_URI="https://github.com/lordmauve/${PN}/archive/${MY_PV}.tar.gz -> ${PN}-${MY_PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~arm64"
IUSE=""
RESTRICT="nomirror"

DEPEND="
	dev-python/pygame
"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${PN}-${MY_PV}"

PATCHES=( ${FILESDIR}/pgzero-setup.patch )

pkg_postinst(){
	ewarn
	ewarn 'If you are using >=pygame-2.0'
	ewarn 'then add a global variable:'
	ewarn 'export PYGAME_BLEND_ALPHA_SDL2=1'
	ewarn 'this will speed up the application'
	ewarn
}
