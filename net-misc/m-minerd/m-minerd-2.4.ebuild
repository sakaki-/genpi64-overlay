# Copyright (c) 2018 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6

inherit autotools

DESCRIPTION="CPU pool miner for M7M/Magi (XMG)"
HOMEPAGE="https://github.com/magi-project/m-cpuminer-v2"
IUSE=""
RESTRICT="mirror"
LICENSE="GPL-2"
SLOT="0"
DEPEND="
	dev-libs/gmp:0
	dev-libs/jansson
	>=net-misc/curl-7.15[ssl]
	dev-libs/openssl:0=
"
RDEPEND="${DEPEND}"
if [[ ${PV} == "9999" ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="${HOMEPAGE}.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm64"
	SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

S="${WORKDIR}/m-cpuminer-v2-${PV}"

src_prepare() {
	default
	eautoreconf
}

