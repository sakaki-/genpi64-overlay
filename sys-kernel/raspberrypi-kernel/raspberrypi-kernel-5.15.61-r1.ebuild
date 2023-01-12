# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# Largely derived from gentoo-kernel-5.15.86.ebuild

EAPI=8

inherit pikernel-build

MY_P=linux-1.20220830
GENPATCHES_P=genpatches-${PV%.*}-$(( ${PV##*.} + 7 ))
# https://koji.fedoraproject.org/koji/packageinfo?packageID=8
CONFIG_VER=5.15.19
CONFIG_HASH=ec69da7a42b5b7c3da91572ef22097b069ddbd01
GENTOO_CONFIG_VER=g1

DESCRIPTION="Raspberry Pi Foundation Linux kernel built with Gentoo patches"
HOMEPAGE="https://www.kernel.org/ https://github.com/raspberrypi/linux"
SRC_URI+=" https://github.com/raspberrypi/linux/archive/refs/tags/1.20220830.tar.gz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
	https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
	https://github.com/projg2/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
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
	)
"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2"
KEYWORDS="~arm arm64"
IUSE=" debug "

RDEPEND="
	!sys-kernel/gentoo-kernel:${SLOT}
	!sys-kernel/gentoo-kernel-bin:${SLOT}
	!sys-kernel/vanilla-kernel:${SLOT}
	!sys-kernel/vanilla-kernel-bin:${SLOT}
"
BDEPEND="
	debug? ( dev-util/pahole )
"
PDEPEND="
	>=virtual/dist-kernel-${PV}
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
	usr/src/linux-.*/arch/powerpc/kernel/vdso.*/vdso.*.so.dbg
"

src_prepare() {
	local PATCHES=(
		# meh, genpatches have no directory
		"${WORKDIR}"/{15,2,4}*.patch
	)
	default
}

# Override function from kernel-install eclass to skip checking of kernel.release file(s).
pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"
}
