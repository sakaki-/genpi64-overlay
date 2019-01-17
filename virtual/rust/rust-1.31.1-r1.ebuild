# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for Rust language compiler"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

BDEPEND=""
RDEPEND="|| ( =dev-lang/rust-${PV}* =dev-lang/rust-bin-${PV}* )"

# With rust taking over installation of cargo at v1.31.1 (from the
# explict package) we can get a situation where during upgrade, it
# cannot create the /usr/bin/cargo link (as the old dev-util/cargo
# package still has a file there, and has not yet been uninstalled).
# However, that will all have happened by the time this package is
# installed. We're a virtual, and the rules say virtuals install no
# files, so we'll, er, just call the eselect function to do it on our
# behalf (if necessary), so upgrading users don't get left with a broken
# system.
pkg_postinst() {
	if [[ ! -h "${ROOT%/}/usr/bin/cargo" ]]; then
		ewarn "Fixing missing ${ROOT%/}/usr/bin/cargo symlink..."
		eselect rust set rust-1.31.1
	else
		einfo "${ROOT%/}/usr/bin/cargo symlink already present"
	fi
}
