# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools flag-o-matic systemd

DESCRIPTION="Multi algo CPU miner"
HOMEPAGE="https://github.com/tpruvot/cpuminer-multi"
IUSE="cpu_flags_x86_sse2 +curl libressl"
LICENSE="GPL-2"
SLOT="0"
REQUIRED_USE="amd64? ( cpu_flags_x86_sse2 )"
DEPEND="
	dev-libs/gmp:0
	dev-libs/jansson
	curl? ( >=net-misc/curl-7.15[ssl] )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	!net-p2p/cpuminer-opt
"
RDEPEND="${DEPEND}"
if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/tpruvot/${PN}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="https://github.com/tpruvot/${PN}/archive/v${PV}-multi.tar.gz -> ${P}.tar.gz"
fi

S="${WORKDIR}/${P}-multi"

pkg_pretend() {
	if use arm64 && ! is-flagq '-Ofast'; then
		ewarn "Upstream recommends compiling with -Ofast on arm64"
	fi
}


src_prepare() {
	default
	find "${S}" -name '*.a' -o -name '*.lib' -delete
	eautoreconf
}

src_configure() {
	append-ldflags -Wl,-z,noexecstack
	local myconf="--with-crypto"
	myconf+=( $(use_with curl) )
	if use arm64 ; then
		myconf+=( --disable-assembly )
	fi

	econf "${myconf[@]}"
}

src_install() {
	default
	systemd_dounit "${FILESDIR}"/${PN}.service
	insinto "/etc/${PN}"
	doins cpuminer-conf.json
}
