# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pikernel-build

MY_P=linux-rpi-${PV%.*}.y_20201122
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 2 ))
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.10.0
CONFIG_HASH=12700e38e8ba0a7be437a4c5804ba0e6417fdc24
GENTOO_CONFIG_VER=5.9.8-r1

IUSE+=" debug "

DESCRIPTION="Raspberry Pi Foundation Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/ https://github.com/raspberrypi/linux"
SRC_URI+=" https://github.com/raspberrypi/linux/archive/rpi-5.10.y_20201122.tar.gz
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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}"
BDEPEND="
	debug? ( dev-util/dwarves )"

src_prepare() {
    local PATCHES=(
	"${WORKDIR}"/{15,19,2,4}*.patch
    )
    default
    ebegin "Selecting Kernel Config"
    
    local merge_configs=(
	"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/base.config
    )
    use debug || merge_configs+=(
	    "${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/no-debug.config
	)
    pikernel-build_merge_configs "${merge_configs[@]}"
}
