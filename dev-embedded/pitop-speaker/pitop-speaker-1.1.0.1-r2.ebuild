# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6
PYTHON_COMPAT=( python3_{4,5,6} )

inherit distutils-r1 versionator

MY_PN="ptspeaker"
MY_P="${MY_PN}-$(replace_version_separator 3 '.post')"

DESCRIPTION="Initialize the pi-topSPEAKER addon board"
HOMEPAGE="https://pypi.python.org/pypi/${MY_PN}"
SRC_URI="https://pypi.org/packages/source/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0 GPL-3+"
SLOT="0"
KEYWORDS="~arm ~arm64"
RESTRICT="mirror"

RDEPEND="
	|| (
		>=sys-apps/rpi3-i2cdev-1.0.0-r2
		>=sys-apps/rpi-i2c-1.0.0-r2
	)
	>=sys-apps/i2c-tools-3.1.1-r1[python]
	>=media-sound/alsa-utils-1.1.2
	>=sys-apps/openrc-0.21
	>=app-shells/bash-4.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

python_prepare_all() {
	# change location of setup.cfg I2C script
	sed -i \
		-e "s:CFG_FILE_PATH = .*:CFG_FILE_PATH = \"/usr/share/${PN}/setup.cfg\":" \
		"${S}/${MY_PN}/configuration.py" || die "failed to patch configuration.py"
		# supplied code files have no header block; the following
		# comes from Debian's package
		echo "Python and I2C files copyright (c) 2017 CEED Ltd." > \
			"${S}/${MY_PN}/copyright"
		echo "License: Apache-2.0" >> "${S}/${MY_PN}/copyright"

	distutils-r1_python_prepare_all
}

python_install_all() {
	distutils-r1_python_install_all

	# install I2C script file (used to setup the speaker DAC etc.)
	insinto /usr/share/${PN}
	doins "${S}/${MY_PN}/setup.cfg"
	doins "${S}/${MY_PN}/copyright"

	newinitd "${FILESDIR}/init.d_${PN}-2" "${PN}"
	newconfd "${FILESDIR}/conf.d_${PN}-1" "${PN}"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "The ${PN} service has been installed."
		elog "To enable it, please run:"
		elog "  rc-update add ${PN} default"
		elog "(and, if doing so, also be sure to enable the"
		elog "rpi3-i2cdev boot service, and to set:"
		elog "  dtparam=i2c_arm=on"
		elog "  hdmi_drive=2"
		elog "  dtparam=audio=on"
		elog "in /boot/config.txt)."
		elog ""
		elog "Please also ensure you have the correct speakers for"
		elog "you system specified in /etc/conf.d/${PN}"
	fi
}
