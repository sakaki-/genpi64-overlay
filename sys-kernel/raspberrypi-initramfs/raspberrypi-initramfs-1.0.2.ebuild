# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Assembles a simple initramfs, suitable for use on Raspberry Pi 3 and Raspberry Pi 4 SBCs.  Contains busybox shell, micropython, /sbin/init written in micropython, and basic filesystem utilities.  Additional files can be specified via /etc/kernel/initramfs.d/*.conf."
HOMEPAGE="https://github.com/GenPi64/PiInitramfs"
SRC_URI="${HOMEPAGE}/archive/refs/tags/${PV}.tar.gz"

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


src_unpack() {
	default
	git clone https://github.com/micropython/micropython-lib
	mkdir -p initramfs/lib
	mkdir -p initramfs/usr/lib/micropython
	mkdir "raspberrypi-initramfs-${PV}"
}

src_prepare() {
	pushd ../micropython-lib
	echo PREFIX=${WORKDIR}/initramfs/usr/lib/micropython > Makefile.patched
	cat Makefile | grep -v "PREFIX =" >> Makefile.patched
	mv Makefile.patched Makefile
	popd
	default
}


src_compile() {
	pushd ../micropython-lib
	make install
	popd
	pushd ../initramfs
	mkdir bin
	cp /bin/busybox bin
	cp /sbin/btrfs bin
	cp /sbin/btrfstune bin
	cp /usr/bin/micropython bin
	cp /sbin/blkid bin
	cp /sbin/findfs bin

	cp /lib64/ld-linux-aarch64.so.1 lib
	cp /lib64/libc.so.6 lib
	cp /lib64/libm.so.6 lib
	cp /lib64/libdl.so.2 lib
	cp /usr/lib64/libffi.so.7 lib
	cp /lib64/libuuid.so.1 lib
	cp /lib64/libblkid.so.1 lib
	cp /lib64/libmount.so.1 lib
	cp /lib64/libz.so.1 lib
	cp /lib64/liblzo2.so.2 lib
	cp /usr/lib64/libzstd.so.1 lib
	cp /lib64/libpthread.so.0 lib
	cp /lib64/libpcre.so.1 lib

	cp -r ${WORKDIR}/PiInitramfs-${PV}/{LICENSE.txt,init,bin} .
	cp -r ${WORKDIR}/PiInitramfs-${PV}/lib/python/* usr/lib/micropython/

	mkdir -p {bin,dev,etc,lib,newroot,proc,sys}
	touch {bin,dev,etc,lib,newroot,proc,sys}/.keep

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
}
