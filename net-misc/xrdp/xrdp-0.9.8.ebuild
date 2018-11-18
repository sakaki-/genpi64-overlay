# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools eutils pam systemd

DESCRIPTION="An open source Remote Desktop Protocol server"
HOMEPAGE="http://www.xrdp.org/"
SRC_URI="https://github.com/neutrinolabs/xrdp/releases/download/v${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="mirror"
IUSE="debug fuse kerberos jpeg -neutrinordp pam +pulseaudio systemd -xrdpvr"

RDEPEND="dev-libs/openssl:0=
	media-sound/pulseaudio:0=
	x11-libs/libX11:0=
	x11-libs/libXfixes:0=
	x11-libs/libXrandr:0=
	fuse? ( sys-fs/fuse:0= )
	jpeg? ( virtual/jpeg:0= )
	kerberos? ( virtual/krb5:0= )
	pam? ( virtual/pam:0= )
	neutrinordp? ( net-misc/freerdp:0= )
	xrdpvr? ( virtual/ffmpeg:0= )"
DEPEND="${RDEPEND}
	app-arch/xz-utils"
# RDEPEND="${RDEPEND}
#     || (
#         net-misc/tigervnc:0[server,xorgmodule]
#         net-misc/x11rdp:0
#     )"

src_prepare() {
	# don't let USE=debug adjust CFLAGS
	sed -i -e 's/-g -O0//' configure.ac || die
	# disallow root login by default
	sed -i -e '/^AllowRootLogin/s/true/false/' sesman/sesman.ini || die

	eautoreconf
}

src_configure() {
	use kerberos && use pam \
		&& ewarn "Both kerberos & pam auth enabled, kerberos will take precedence."

	local myconf=(
		# warning: configure.ac is completed flawed

		--localstatedir="${EPREFIX}"/var

		# -- authentication backends --
		# kerberos is inside !SESMAN_NOPAM conditional for no reason
		$(use pam || use kerberos || echo --enable-nopam)
		$(usex kerberos --enable-kerberos '')
		# pam_userpass is not in Gentoo at the moment
		#--disable-pamuserpass

		# -- jpeg support --
		$(usex jpeg --enable-jpeg '')
		# the package supports explicit linking against libjpeg-turbo
		# (no need for -ljpeg compat)
		$(use jpeg && has_version 'media-libs/libjpeg-turbo:0' && echo --enable-tjpeg)

		# -- others --
		$(usex debug --enable-xrdpdebug '')
		$(usex fuse --enable-fuse '')
		# $(usex neutrinordp --enable-neutrinordp '')
		# $(usex xrdpvr --enable-xrdpvr '')

		"$(systemd_with_unitdir)"
	)

	econf "${myconf[@]}"
}

src_install() {
	default
	prune_libtool_files --all

	# use our pam.d file since upstream's incompatible with Gentoo
	use pam && newpamd "${FILESDIR}"/xrdp-sesman.pamd xrdp-sesman
	# and our startwm.sh
	exeinto /etc/xrdp
	doexe "${FILESDIR}"/startwm.sh

	# own /etc/xrdp/rsakeys.ini
	: > rsakeys.ini
	insinto /etc/xrdp
	doins rsakeys.ini

	# contributed by Jan Psota <jasiupsota@gmail.com>
	newinitd "${FILESDIR}/${PN}-initd" ${PN}
}

pkg_preinst() {
	# either copy existing keys over to avoid CONFIG_PROTECT whining
	# or generate new keys (but don't include them in binpkg!)
	if [[ -f ${EROOT}/etc/xrdp/rsakeys.ini ]]; then
		cp {"${EROOT}","${ED}"}/etc/xrdp/rsakeys.ini || die
	else
		einfo "Running xrdp-keygen to generate new rsakeys.ini ..."
		"${S}"/keygen/xrdp-keygen xrdp "${ED}"/etc/xrdp/rsakeys.ini \
			|| die "xrdp-keygen failed to generate RSA keys"
	fi
}

pkg_postinst() {
	# check for use of bundled rsakeys.ini (installed by default upstream)
	if [[ $(cksum "${EROOT}"/etc/xrdp/rsakeys.ini) == '2935297193 1019 '* ]]
	then
		ewarn "You seem to be using upstream bundled rsakeys.ini. This means that"
		ewarn "your communications are encrypted using a well-known key. Please"
		ewarn "consider regenerating rsakeys.ini using the following command:"
		ewarn
		ewarn "  ${EROOT}/usr/bin/xrdp-keygen xrdp ${EROOT}/etc/xrdp/rsakeys.ini"
		ewarn
	fi

	elog "Various session types require different backend implementations:"
	elog "- sesman-Xvnc requires net-misc/tigervnc[server,xorgmodule]"
	elog "- sesman-X11rdp requires net-misc/x11rdp"
}
