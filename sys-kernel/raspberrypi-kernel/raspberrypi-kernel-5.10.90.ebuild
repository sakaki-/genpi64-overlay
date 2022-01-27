# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pikernel-build

PV=${PV}

MY_P=linux-raspberrypi-kernel_1.20220120
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 7 ))
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.10.12
CONFIG_HASH=836165dd2dff34e4f2c47ca8f9c803002c1e6530
GENTOO_CONFIG_VER=5.15.5

IUSE+=" debug "

DESCRIPTION="Raspberry Pi Foundation Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/ https://github.com/raspberrypi/linux"
SRC_URI+=" https://github.com/raspberrypi/linux/archive/refs/tags/1.20220120.tar.gz
               -> 1.20220120.tar.gz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/mgorny/gentoo-kernel-config/archive/v${GENTOO_CONFIG_VER}.tar.gz
		-> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	amd64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-x86_64-fedora.config
			-> kernel-x86_64-fedora.config.${CONFIG_VER}
	)
	arm64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-aarch64-fedora.config
			-> kernel-aarch64-fedora.config.${CONFIG_VER}
	)
	ppc64? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-ppc64le-fedora.config
			-> kernel-ppc64le-fedora.config.${CONFIG_VER}
	)
	x86? (
		https://src.fedoraproject.org/rpms/kernel/raw/${CONFIG_HASH}/f/kernel-i686-fedora.config
			-> kernel-i686-fedora.config.${CONFIG_VER}
	)"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm arm64 ~ppc64 ~x86"

RDEPEND="
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/dwarves )"

src_prepare() {
    local PATCHES=(
	"${WORKDIR}"/{15,2,4}*.patch
    )
    default
}

# Override function from kernel-install eclass to skip checking of kernel.release file(s).
pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"
}

