# Copyright (c) 2020 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=7

DESCRIPTION="Ensure correct keyboard layout applied on graphical login"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi-64bit"
SRC_URI=""

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND="
	>=xfce-base/xfce4-meta-4.12
	>=xfce-base/xfconf-4.14.1
	>=x11-apps/setxkbmap-1.3.2
	>=x11-terms/xfce4-terminal-0.8.6"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.0"

src_install() {
	newbin "${FILESDIR}/xfce4-kbsetup-2" "kbsetup"
	insinto "/etc/xdg/autostart/"
	newins "${FILESDIR}/${PN}.desktop-1" "kbsetup.desktop" 
}

