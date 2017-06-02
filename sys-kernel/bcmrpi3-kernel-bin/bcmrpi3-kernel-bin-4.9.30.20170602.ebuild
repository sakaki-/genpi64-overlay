# Copyright (c) 2016 sakaki <sakaki@deciban.com>
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="6"

inherit eutils autotools

DESCRIPTION="Binary RPi3 64-bit kernel package (bcmrpi3_defconfig)"
HOMEPAGE="https://github.com/sakaki-/bcmrpi3-kernel"

SRC_URI="${HOMEPAGE}/releases/download/${PV}/bcmrpi3-kernel-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2 freedist"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+checkboot firmware"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="*"

S="${WORKDIR}"

# ebuild function overrides

pkg_pretend() {
	# check /boot directory is mounted, provided $ROOT is /
	if use checkboot && [[ "${ROOT}" == "/" ]]; then
		if ! grep -q "^/boot$" <(cut -d " " -f 2 "/proc/mounts") &>/dev/null; then
			die "Your /boot directory does not appear to be mounted"
		fi
	else
		ewarn 'Installing into non-default $ROOT'
		ewarn "Not checking whether /boot is mounted"
	fi
}

src_install() {
	# just copy tarball contents into temporary install root
	cp -r "${S}/boot" "${D}/"
	cp -r "${S}/lib/modules" "${D}/lib/"
	if use firmware; then
		# NB may cause collisions if linux-firmware installed
		cp -r "${S}/lib/firmware" "${D}/lib/"
	fi
}

pkg_postinst() {
	einfo "Your new kernel has been installed."
	einfo "Reboot your system to start using it."
}
