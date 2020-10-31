# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils flag-o-matic git-r3

DESCRIPTION="Raspberry Pi userspace tools and libraries"
HOMEPAGE="https://github.com/raspberrypi/userland"
SRC_URI=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="~arm ~arm64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
		!media-libs/raspberrypi-userland-bin"

EGIT_REPO_URI="https://github.com/raspberrypi/userland"
# latest commit, as of of ebuild's version (datestamp)
EGIT_COMMIT="2fe4ca33dc29dc3ede0044d53b0c0abe0ea6536b"

PATCHES=( "${FILESDIR}/${P}-fix-gcc10-build.patch" )

pkg_setup() {
		append-ldflags $(no-as-needed)
}

src_prepare() {
		default
		sed -i 's/__bitwise/FDT_BITWISE/' "${S}/opensrc/helpers/libfdt/libfdt_env.h"
		sed -i 's/__force/FDT_FORCE/' "${S}/opensrc/helpers/libfdt/libfdt_env.h"
}

src_configure() {
		local mycmakeargs=(
				-DVMCS_INSTALL_PREFIX="/usr"
		)
		if use arm64; then
				mycmakeargs+=(-DARM64=ON)
		fi

		cmake-utils_src_configure
}

src_install() {
		cmake-utils_src_install

		insinto /lib/udev/rules.d
		doins "${FILESDIR}"/92-local-vchiq-permissions.rules

		dodir /usr/share/doc/${PF}
		mv "${D}"/usr/src/hello_pi "${D}"/usr/share/doc/${PF}/
		rmdir "${D}"/usr/src

		# remove potential collisions
		rm -rf "${D}/usr/include/GLES"
		rm -rf "${D}/usr/include/GLES2"
		rm -rf "${D}/usr/include/EGL"
		rm -rf "${D}/usr/include/KHR"

		# hacky fix for multilib issue
		dodir "/usr/$(get_libdir)"
		mv "${D}/usr/lib/"*.so "${D}/usr/$(get_libdir)/"

		# hacky fix for /usr/etc path
		mv "${D}/usr/etc" "${D}/"
}
