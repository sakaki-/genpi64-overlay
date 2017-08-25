# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

inherit versionator

DESCRIPTION="A volume control panel plug-in for Xfce, using volumeicon"
HOMEPAGE="https://git.xfce.org/apps/xfce4-mixer/"
SRC_URI=""

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~arm64"
IUSE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

RDEPEND=">=media-sound/volumeicon-0.5.1
	>=xfce-base/xfce4-meta-4.12
	>=x11-terms/xfce4-terminal-0.8.6
	>=media-sound/alsa-utils-1.1.4-r1"
DEPEND="${RDEPEND}
	>=app-shells/bash-4.0"

src_install() {
	insinto "/usr/share/${PN}"
	newins "${FILESDIR}/volumeicon-1" "volumeicon"
	newbin "${FILESDIR}/start-volumeicon-2" "start-volumeicon"
	insinto "/etc/xdg/autostart/"
	newins "${FILESDIR}/${PN}.desktop-1" "${PN}.desktop" 
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]] || [[ ${REPLACING_VERSIONS} < 4.99 ]]; then
		elog "As the 'real' xfce4-mixer has been treecleaned (bug 628424)"
		elog "it has been replaced by this pseudo-package, which pulls in"
		elog "media-sound/volumeicon instead, and also installs an entry"
		elog "in /etc/xdg/autostart, to run it on graphical logon."
	fi
}
