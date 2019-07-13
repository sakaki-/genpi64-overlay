# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit eutils autotools

DESCRIPTION="Binary RPi3 64-bit kernel package (bcmrpi3_defconfig + tweaks)"
HOMEPAGE="https://github.com/sakaki-/bcmrpi3-kernel-bis"

SRC_URI="${HOMEPAGE}/releases/download/${PV}/bcmrpi3-kernel-bis-${PV}.tar.xz -> ${P}.tar.xz"

LICENSE="GPL-2 freedist"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+checkboot +with-matching-boot-fw pitop"

RESTRICT="mirror"

DEPEND="
	!sys-kernel/bcmrpi3-kernel-bin"
RDEPEND="
	with-matching-boot-fw? ( ~sys-boot/rpi3-64bit-firmware-1.20190620_p1[pitop(-)?,-dtbo(+)] )
	${DEPEND}"

QA_PREBUILT="*"

S="${WORKDIR}"

# ebuild function overrides

pkg_pretend() {
	# check /boot directory is mounted, provided $ROOT is /
	if use checkboot && [[ "${ROOT%/}" == "" ]]; then
		if ! grep -q "^/boot$" <(cut -d " " -f 2 "/proc/mounts") &>/dev/null; then
			die "Your /boot directory does not appear to be mounted"
		fi
	else
		ewarn 'Installing into non-default $ROOT'
		ewarn "Not checking whether /boot is mounted"
	fi
}

src_install() {
	local RELEASE_NAME

	# just copy tarball contents into temporary install root
	insinto /boot
	doins -r "${S%/}/boot"/*
	# remove the pi4 dtb, if we installed it
	rm -f "${D%/}/boot/bcm2711-rpi-4-b.dtb"
	insinto /lib/modules
	doins -r "${S%/}/lib/modules"/*

	# note that we installed the libraries, for future cleanup
	RELEASE_NAME=$(head -n1 <(ls -t1d "${S}/lib/modules"/*))
	RELEASE_NAME="${RELEASE_NAME##*/}"
	echo "${PF}" > "${D%/}/lib/modules/${RELEASE_NAME}/owning_binpkg"
}

pkg_postinst() {
	elog "Your new kernel has been installed."
	elog "Reboot your system to start using it."
}

pkg_postrm() {
	# it is possible that if the kernel originally installed by this ebuild
	# is currently running, then its /lib/modules/<release_name> directory
	# will still be present, due to some of the module files therein having
	# been marked as "in use", leading Portage deline to delete them during
	# the default uninstall phase
	# detect if this has happened and, if so, forcibly (and recursively)
	# delete /lib/modules/<release_name>, and print a warning
	local MDIR OWNING_BINPKG

	shopt -s nullglob
	for MDIR in "${ROOT%/}/lib/modules"/*; do
		# was this kernel installed by a binary package?
		if [[ -s "${MDIR}/owning_binpkg" ]]; then
			OWNING_BINPKG="$(<"${MDIR}/owning_binpkg")"
			# was it us? (also check this is not a pure re-install)
			if [[ "${PF}" == "${OWNING_BINPKG}" && "${PVR}" != "${REPLACED_BY_VERSION}" ]]; then
				# yes, we installed it, we need to remove it
				ewarn "Forcibly deleting kernel module directory ${MDIR}"
				rm -rf "${MDIR}"
				# warn user if this is a 'pure' uninstall,
				# rather than an upgrade
				if [[ -z "${REPLACED_BY_VERSION}" ]]; then
					ewarn "Please ensure you have a valid kernel and module set"
					ewarn "in place, before rebooting."
				fi
			fi
		fi
	done
	shopt -u nullglob
}
