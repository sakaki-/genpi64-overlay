# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: pikernel-build.eclass
# @MAINTAINER:
# GenPi64 Project ( https://github.com/GenPi64 )
# @SUPPORTED_EAPIS: 7
# @BLURB: Build mechanics for Distribution Kernels for Raspberry Pi
# @DESCRIPTION:
# This eclass provides the logic to build a Distribution Kernel for
# Raspberry Pis from source and install it.  Post-install and test
# logic is inherited  from kernel-install.eclass.
#
# The ebuild must take care of unpacking the kernel sources, copying
# an appropriate .config into them (e.g. in src_prepare()) and setting
# correct S.  The eclass takes care of respecting savedconfig, building
# the kernel and installing it along with its modules and subset
# of sources needed to build external modules.
#
# Based off / inherits from kernel-build.eclass by Michał Górny <mgorny@gentoo.org>

inherit kernel-build

IUSE="bcmrpi bcm2709 bcmrpi3 +bcm2711 -initramfs"
REQUIRED_USE="|| ( bcmrpi bcm2709 bcmrpi3 bcm2711 )"

SLOT="0"

pikernel-build_get_targets() {
	targets=()
	configs=()
	for n in bcmrpi bcm2709 bcmrpi3 bcm2711
	do
	if use ${n}; then
		ebegin "using $n"
		targets+=( "${n}" )
		mkdir -p "${WORKDIR}/${n}" || die
		configs+=( "${n}/.config" )
	fi
	done
}


# @FUNCTION: pikernel-build_src_configure
# @DESCRIPTION:
# Prepare the toolchain for building the kernel, get the default .config
# or restore savedconfig, and get build tree configured for modprep.
pikernel-build_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"
	pikernel-build_get_targets
	restore_config "${configs[@]}"
	local merge_configs=(
		"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/base.config
	)
	use debug || merge_configs+=(
		"${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"/no-debug.config
	)

	for n in "${targets[@]}"
	do
		[[ -f $n/.config ]] || emake O="${WORKDIR}/${n}" ARCH=arm64 CROSS_COMPILE=aarch64-unknown-linux-gnu- "${n}_defconfig"
		export CHOST=aarch64-unknown-linux-gnu
		internal_src_configure $n
		ebegin "Selecting Kernel Config"
	done
	pikernel-build_merge_configs "${merge_configs[@]}"
}

# Almost the same as kernel-build_src_configure
# but some parts got chopped off, and
# the last line is changed to support being called in a for-loop.
# TODO: It'd be great if we could call kernel-build_src_configure instead
internal_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	# force ld.bfd if we can find it easily
	local LD="$(tc-getLD)"
	if type -P "${LD}.bfd" &>/dev/null; then
		LD+=.bfd
	fi

	tc-export_build_env
	MAKEARGS=(
		V=1

		HOSTCC="$(tc-getBUILD_CC)"
		HOSTCXX="$(tc-getBUILD_CXX)"
		HOSTCFLAGS="${BUILD_CFLAGS}"
		HOSTLDFLAGS="${BUILD_LDFLAGS}"

		CROSS_COMPILE=${CHOST}-
		AS="$(tc-getAS)"
		CC="$(tc-getCC)"
		LD="${LD}"
		AR="$(tc-getAR)"
		NM="$(tc-getNM)"
		STRIP=":"
		OBJCOPY="$(tc-getOBJCOPY)"
		OBJDUMP="$(tc-getOBJDUMP)"

		# we need to pass it to override colliding Gentoo envvar
		ARCH=$(tc-arch-kernel)
	)
	emake O="${WORKDIR}/${1}" "${MAKEARGS[@]}" olddefconfig
}


# @FUNCTION: kernel-build_src_compile
# @DESCRIPTION:
# Compile the kernel sources.
pikernel-build_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	pikernel-build_get_targets
	for n in "${targets[@]}"
	do
		emake O="${WORKDIR}/$n" "${MAKEARGS[@]}" Image modules dtbs
	done
}


# @FUNCTION: kernel-build_src_install
# @DESCRIPTION:
# Install the built kernel along with subset of sources
# into /usr/src/linux-${PV}.  Install the modules.  Save the config.
pikernel-build_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	pikernel-build_get_targets

	for n in "${targets[@]}"
	do
		emake O="${WORKDIR}/${n}" "${MAKEARGS[@]}" INSTALL_MOD_PATH="${ED}" INSTALL_PATH="${ED}/boot" modules_install
	done

	# note: we're using mv rather than doins to save space and time
	# install main and arch-specific headers first, and scripts
	local kern_arch=$(tc-arch-kernel)
	local ver="${PV}"
	dodir "/usr/src/linux-${ver}/arch/${kern_arch}"
	mv include scripts "${ED}/usr/src/linux-${ver}/" || die
	mv "arch/${kern_arch}/include" "${ED}/usr/src/linux-${ver}/arch/${kern_arch}/" || die
	# some arches need module.lds linker script to build external modules
	if [[ -f arch/${kern_arch}/kernel/module.lds ]]; then
		insinto "/usr/src/linux-${ver}/arch/${kern_arch}/kernel"
		doins "arch/${kern_arch}/kernel/module.lds"
	fi

	# remove everything but Makefile* and Kconfig*
	find -type f '!' '(' -name 'Makefile*' -o -name 'Kconfig*' ')' -delete || die
	find -type l -delete || die
	cp -p -R * "${ED}/usr/src/linux-${ver}/" || die

	cd "${WORKDIR}" || die
	for n in "${targets[@]}"
	do
		ebegin "Installing ${n}"
		if [ "${n}" == "bcmrpi3" ]; then
			KERNEL=kernel8
			export KERNEL_SUFFIX=-v8
		else
			KERNEL=kernel8-p4
			export KERNEL_SUFFIX=-v8-p4
		fi
		insinto "/boot/"
		doins "${n}"/arch/arm64/boot/dts/broadcom/*.dtb
		cp "${n}/arch/arm64/boot/Image" "${n}/arch/arm64/boot/$KERNEL.img"
		doins "${n}/arch/arm64/boot/$KERNEL.img"
		insinto "/boot/overlays"
		doins "${n}"/arch/arm64/boot/dts/overlays/*.dtb*

		insinto "/usr/src/linux-${ver}${KERNEL_SUFFIX}"
		doins "${targets[0]}"/{System.map,Module.symvers}

		# fix source tree and build dir symlinks
		dosym ../../../usr/src/linux-${ver} /lib/modules/${ver}${KERNEL_SUFFIX}/build
		dosym ../../../usr/src/linux-${ver} /lib/modules/${ver}${KERNEL_SUFFIX}/source
	done
	save_config "${configs[@]}"
}

# Hack: Override function from kernel-install eclass to skip checking of kernel.release file(s).
pikernel-build_pkg_preinst() {
	debug-print-function ${FUNCNAME} "${@}"
}

# Hack: Override function from kernel-install eclass to skip building of initramfs.
pikernel-build_pkg_postinst() {
	debug-print-function ${FUNCNAME} "${@}"
}

# @FUNCTION: kernel-build_merge_configs
# @USAGE: [distro.config...]
# @DESCRIPTION:
# Merge the config files specified as arguments (if any) into
# the '.config' file in the current directory, then merge
# any user-supplied configs from ${BROOT}/etc/kernel/config.d/*.config.
# The '.config' file must exist already and contain the base
# configuration.
pikernel-build_merge_configs() {
	debug-print-function ${FUNCNAME} "${@}"
	get_targets
	ebegin "Merging kernel configs"
	for f in "${targets[@]}"
	do
		if [ "${f}" == "bcmrpi3" ]; then
			KERNEL=kernel8
			export KERNEL_SUFFIX=-v8
		else
			KERNEL=kernel8-p4
			export KERNEL_SUFFIX=-v8-p4
		fi

		[[ -f "${WORKDIR}/${f}/.config" ]] || die "${FUNCNAME}: {$f}/.config does not exist"
		has .config "${@}" && die "${FUNCNAME}: do not specify .config as parameter"

		local shopt_save=$(shopt -p nullglob)
		shopt -s nullglob
		local user_configs=( "${BROOT}"/etc/kernel/config.d/*.config )
		shopt -u nullglob

		if [[ ${#user_configs[@]} -gt 0 ]]; then
			elog "User config files are being applied:"
			local x
			for x in "${user_configs[@]}"; do
				elog "- ${x}"
			done
		fi

		cd "${WORKDIR}/${f}"

		./source/scripts/kconfig/merge_config.sh -m -r ".config" "${@}" "${user_configs[@]}" || die
		if [ "${f}" == "bcmrpi3" ]; then
			sed -i -E "s_CONFIG\_LOCALVERSION=.*\$_CONFIG\_LOCALVERSION=\"-v8\"_" .config
		else
			sed -i -E "s_CONFIG\_LOCALVERSION=.*\$_CONFIG\_LOCALVERSION=\"-v8-p4\"_" .config
		fi

	done
}

EXPORT_FUNCTIONS src_configure src_compile src_install pkg_postinst
