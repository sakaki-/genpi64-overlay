# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS="no"

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1 gnome2-utils

DESCRIPTION="Onscreen keyboard for everybody who can't use a hardware keyboard"

HOMEPAGE="https://launchpad.net/onboard"

# Using of PN variable avoided, Following note in
# https://wiki.gentoo.org/wiki/Basic_guide_to_write_Gentoo_Ebuilds
SRC_URI="https://launchpad.net/onboard/$(ver_cut 1-2)/${PV}/+download/${P}.tar.gz"

# po/* are licensed under BSD 3-clause
LICENSE="GPL-3+ BSD"

SLOT="0"

KEYWORDS="~amd64 arm arm64 ~x86"

COMMON_DEPEND="app-text/hunspell:=
	dev-libs/dbus-glib
	dev-python/dbus-python[${PYTHON_USEDEP}]
	dev-python/pycairo[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	dev-python/python-distutils-extra[${PYTHON_USEDEP}]
	gnome-base/dconf
	gnome-base/gsettings-desktop-schemas
	gnome-base/librsvg
	media-libs/libcanberra
	sys-apps/dbus
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3[introspection]
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXtst
	x11-libs/libwnck:3
	x11-libs/pango"
DEPEND="${COMMON_DEPEND}
	dev-util/intltool"
RDEPEND="${COMMON_DEPEND}
	app-accessibility/at-spi2-core
	app-text/iso-codes
	gnome-extra/mousetweaks
	x11-libs/libxkbfile"

src_install() {
	distutils-r1_src_install
	# Delete duplicated docs installed by original distutils
	rm "${D}"/usr/share/doc/onboard/*
}

pkg_preinst() {
	gnome2_icon_savelist
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
}

pkg_postrm() {
	gnome2_icon_cache_update
	gnome2_schemas_update
	xdg_desktop_database_update
}
