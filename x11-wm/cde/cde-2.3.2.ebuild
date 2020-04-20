# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Modified from the original from https://github.com/Hypnos7/overlay (thanks!)

EAPI=4

DESCRIPTION="The Common Desktop Environment, the classic UNIX desktop"
HOMEPAGE="http://cdesktopenv.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/cdesktopenv/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~arm64 ~x86 ~amd64"
IUSE=""

S="${WORKDIR}/${P}"

DEPEND="
		>=x11-base/xorg-proto-2019.2
		x11-libs/libXt
		x11-libs/libXmu
		x11-libs/libXft
		x11-libs/libXinerama
		x11-libs/libXpm
		>=x11-libs/motif-2.3
		x11-libs/libXaw
		x11-libs/libX11
		x11-libs/libXScrnSaver
		net-libs/libtirpc
		x11-apps/xset
		virtual/jpeg
		media-libs/freetype:2
		dev-lang/tcl
		app-shells/ksh
		app-arch/ncompress
		media-fonts/font-adobe-100dpi
		media-fonts/font-adobe-utopia-100dpi
		media-fonts/font-bh-100dpi
		media-fonts/font-bh-lucidatypewriter-100dpi
		media-fonts/font-bitstream-100dpi
		net-nds/rpcbind
		x11-misc/xbitmaps"
RDEPEND="${DEPEND}"

src_prepare() {
	mkdir -p imports/x11/include
	cd imports/x11/include
	ln -s /usr/include/X11 .
}

src_compile() {
	#
	# The make invokation below accomplishes the following:
	#
	# (1) xmakefiles need to be generated before anything else.
	#     Maybe there's a more intelligent way to ensure this than to
	#     disable parallel make.
	#
	# (2) Build process shouldn't die, as this is alpha code and some
	#     things are expected not to compile.  So we use make instead
	#     emake, which dies on non-zero return value from build.
	MAKEOPTS="${MAKEOPTS} -j1" make World || true
}

src_install() {
	#
	# Install CDE files
	#
	# The following is based on the installCDE script.
	cd admin/IntegTools/dbTools
	DATABASE_FILES="CDE-RUN CDE-MIN CDE-TT CDE-MAN CDE-HELP-RUN CDE-C \
					CDE-MSG-C CDE-HELP-C CDE-SHLIBS CDE-HELP-PRG \
					CDE-PRG CDE-INC CDE-DEMOS CDE-MAN-DEV CDE-ICONS \
					CDE-FONTS CDE-INFO CDE-INFOLIB-C"
	DATABASE_DIR="${S}"/databases
	for db in ${DATABASE_FILES}; do
		einfo "Fileset ${db}"
		einfo "    ${DATABASE_DIR}/${db}.udb -> ${T}/${db}.lst"
		/bin/ksh ./udbToAny.ksh -toLst -ReleaseStream linux \
			"${DATABASE_DIR}"/"${db}".udb > "${T}"/"${db}".lst
		einfo "    ${T}/${db}.lst -> ${D}"
		/bin/ksh ./mkProd -D "${D}" -S "${S}" "${T}"/"${db}".lst
	done
	# Move stuff that we can out of /usr/dt to comply with FHS
	# as much as possible (more probably requires patching)
	einfo "Relocating some files to comply with FHS as much as"
	einfo "possible.  More probably requires patching ..."
	mv -v "${D}"/usr/dt/{bin,lib} "${D}"/usr/
	mkdir -pv "${D}"/usr/share/man
	mv -v "${D}"/usr/dt/share/man/* "${D}"/usr/share/man/
	# remove collision
	rm -fv "${D}/usr/share/man/man1/ksh.1.bz2"
	ln -sfv "${D}"/usr/share/man "${D}"/usr/dt/man
	#
	# Misc directories
	#
	# These are required according to CDE website wiki
	# (complying with FHS probably requires patching)
	dodir /var/dt
	fperms 0777 /var/dt
	dodir /usr/spool/calendar
	#
	# env.d for /usr/dt paths
	#doenvd "${FILESDIR}"/95cde  # NO LONGER REQUIRED WITH mv ABOVE
}

pkg_postinst() {
	ewarn "The rpcbind daemon must be running for many CDE apps to work."
	ewarn
	ewarn "For now, rpcbind must run in insecure mode.  This is "
	ewarn "accomplished by passing the '-i' command line parameter."
	ewarn "(See /etc/conf.d/rpcbind .)"
}
