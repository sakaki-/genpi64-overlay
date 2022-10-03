# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Assembles a simple initramfs, suitable for use on Raspberry Pi 3 and Raspberry Pi 4 SBCs.  Contains busybox shell, micropython, /sbin/init written in micropython, and basic filesystem utilities.  Additional files can be specified via /etc/kernel/initramfs.d/*.conf."
HOMEPAGE="https://github.com/GenPi64/PiInitramfs"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz -> raspberrypi-initramfs-${PV}.tar.gz"

inherit toolchain-funcs

SLOT="0"
KEYWORDS="arm64 arm"


RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/micropython
		 app-arch/cpio
		 dev-libs/libffi[static-libs]
		 sys-apps/busybox[static]
		 sys-fs/btrfs-progs[static-libs]"

install_one_micropackage() {
    for d in $(find -maxdepth 1 -type d ! -name ".*"); do
	echo $d;
	$(cd $d; sh -c "${INSTALLCMD}");
    done
}


install_micropackages() {
    INSTALLCMD="find . -maxdepth 1 -mindepth 1 \( -name '*.py' -not -name 'test_*' -not -name 'setup.py' -not -name 'example_*' \) -or \( -type d -not -name 'dist' -not -name '*.egg-info' -not -name '__pycache__' \)| xargs --no-run-if-empty cp -r -t ${WORKDIR}/initramfs/usr/lib/micropython"
    pushd ../micropython-lib

    pushd python-stdlib
    install_one_micropackage
    popd

    pushd unix-ffi
    install_one_micropackage
    popd

    popd

}



src_unpack() {
	default
	git clone https://github.com/micropython/micropython-lib || die
	mkdir -p initramfs/lib || die
	mkdir -p initramfs/usr/lib/micropython || die 
	mkdir "raspberrypi-initramfs-${PV}" || die
}

src_compile() {
	pushd ../micropython-lib
        install_micropackages
	popd
	pushd ../initramfs
	mkdir bin
	cp /bin/busybox bin || die
	cp /sbin/btrfs bin || die
	cp /sbin/btrfstune bin || die
	cp /usr/bin/micropython bin || die
	cp /sbin/blkid bin || die
	cp /sbin/findfs bin || die

	cp /lib64/ld-linux-aarch64.so.1 lib || die
	cp /lib64/libc.so.6 lib || die
	cp /lib64/libm.so.6 lib || die
	cp /lib64/libdl.so.2 lib || die
	cp /usr/lib64/libffi.so.8 lib || die
	cp /lib64/libuuid.so.1 lib || die
	cp /lib64/libblkid.so.1 lib || die
	cp /lib64/libmount.so.1 lib || die
	cp /lib64/libz.so.1 lib || die
	cp /lib64/liblzo2.so.2 lib || die
	cp /usr/lib64/libzstd.so lib || die
	cp /lib64/libpthread.so.0 lib || die
	cp /lib64/libpcre.so.1 lib || die

	cp -r ${WORKDIR}/PiInitramfs-${PV}/{LICENSE.txt,init,bin} . || die
	cp -r ${WORKDIR}/PiInitramfs-${PV}/lib/python/* usr/lib/micropython/ || die

	mkdir -p {bin,dev,etc,lib,newroot,proc,sys} || die
	touch {bin,dev,etc,lib,newroot,proc,sys}/.keep || die

	popd

	echo "#!/bin/bash" >> mkinitramfs
	echo "pushd /usr/src/initramfs-${PV}" >> mkinitramfs
	echo "find . -print0 | cpio --null --create --verbose --format=newc | gzip --best > /boot/initramfs-${PV}.cpio.gz" >> mkinitramfs

	chmod +x mkinitramfs
}

src_install() {
	insinto "/usr/src/initramfs-${PV}"
	pushd ${WORKDIR}/initramfs
	doins LICENSE.txt
	doins -r {dev,etc,newroot,proc,sys}

	exeinto "/usr/src/initramfs-${PV}/bin"
	doexe bin/*

	exeinto "/usr/src/initramfs-${PV}/"
	doexe init

	insinto "/usr/src/initramfs-${PV}/lib"
	insopts -m0755
	doins lib/*

	insinto "/usr/src/initramfs-${PV}/usr/lib/micropython"
	doins -r usr/lib/micropython/*



	popd

	exeinto "/usr/bin/"
	doexe mkinitramfs

}

pkg_postinst() {
	/usr/bin/mkinitramfs
	ewarn "This initramfs requires you to manually change /boot/cmdline.txt"
	ewarn "rootwait needs to be changed to rootdelay and config.txt changed to point to the new initramfs"
}
