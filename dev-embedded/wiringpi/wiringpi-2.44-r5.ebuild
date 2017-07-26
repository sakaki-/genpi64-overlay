# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6
inherit flag-o-matic toolchain-funcs git-r3

KEYWORDS="~arm ~arm64"

DESCRIPTION="GPIO interface libraries (and utility) for the Raspberry Pi"
HOMEPAGE="http://wiringpi.com/"
SRC_URI=""
LICENSE="LGPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

EGIT_REPO_URI="git://git.drogon.net/wiringPi"
EGIT_BRANCH="master"
# fetch the branch matching the ebuild version
EGIT_COMMIT="${PV}"

DEPEND=""
RDEPEND="
	${DEPEND}"

src_prepare() {
	local DIR
	# put header files in include subdirectory
	# don't make library links directly (these break)
	# update manpage location to non-deprecated value
	# get rid of suid (security risk); install utility as sbin instead
	# if on arm64, install to /usr/lib64, not /usr/lib
	for DIR in wiringPi devLib gpio; do
		sed -e "s#/include#/include/${PN}#" \
		-e 's:\($Q \)ln -sf:#\1ln -sf:g' \
		-e 's:/man/man:/share/man/man:g' \
		-e 's:/bin:/sbin:g' \
		-e 's:4755:0755:g' \
		-i ${DIR}/Makefile
		if use arm64; then
			sed -e 's:$(PREFIX)/lib:$(PREFIX)/lib64:g' \
			-e 's:/lib/:/lib64/:g'
			-i ${DIR}/Makefile
		fi
	done
	# deal with problem that RPi3 in 64-bit mode does not have
	# the 'Hardware' line in /proc/cpuinfo, which the wiringPi library
	# checks, by making it look in /etc/wiringpi/cpuinfo instead
	use arm64 && epatch "${FILESDIR}/${PV}-pseudo-cpuinfo.patch"
	default
}

src_compile() {
	# git archive contains object files
	cd wiringPi
	emake V=1 clean
	append-cflags "-fPIC" "-I${S}/wiringPi"
	# ensure the right compiler and flags get used
	emake V=1 CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		LDCONFIG=/bin/true
	# set up symlink for library
	ln -s libwiringPi.so.* libwiringPi.so

	# now ditto for other directories

	cd ../devLib
	emake V=1 clean
	append-cflags "-I${S}/devLib"
	emake V=1 CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
		LDCONFIG=/bin/true
	ln -s libwiringPiDev.so.* libwiringPiDev.so

	cd ../gpio
	emake V=1 clean
	append-cflags "-I${S}/cpio"
	append-ldflags "-L${S}/wiringPi" "-L${S}/devLib"
	emake V=1 CC=$(tc-getCC) CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" \
                LDCONFIG=/bin/true
}

src_install() {
	local LIBDIR="${D%/}/usr/lib"
	if use arm64; then
		LIBDIR+="64"
	fi
	cd wiringPi
	emake DESTDIR="${D%/}" PREFIX="/usr" install
	cp --no-dereference libwiringPi.so "${LIBDIR}/"
	cd ../devLib
	emake DESTDIR="${D%/}" PREFIX="/usr" install
	cp --no-dereference libwiringPiDev.so "${LIBDIR}/"
	cd ../gpio
	mkdir -p "${D%/}/usr/sbin"
	emake DESTDIR="${D%/}" PREFIX="/usr" install
	cd ..
	DOCS=( README.TXT People )
	if use arm64; then
		# following is a snippet of cpuinfo, for use on Pi3s (which
		# don't contain all the expected fields when booted in 64-bit
		# mode)
		insinto "/etc/${PN}"
		newins "${FILESDIR}/cpuinfo-1" "cpuinfo"
	fi
	einstalldocs
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] && use arm64; then
		elog "The file /etc/${PN}/cpuinfo has been created."
		elog "The library will look there, instead of /proc/cpuinfo"
		elog "when determining system type; this is necessary because"
		elog "some /proc/cpuinfo data is not output in 64-bit mode."
		elog "It only contains the necessary stanzas."
		elog "You can modify this file as required." 
	fi
}
