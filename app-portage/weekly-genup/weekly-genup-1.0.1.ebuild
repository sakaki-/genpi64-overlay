# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v2 or GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm64"

DESCRIPTION="Installs simple cron.weekly script, to automate genup"
HOMEPAGE="https://github.com/GenPi64/gentoo-on-rpi3-64bit"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""
RESTRICT="mirror"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	virtual/cron
	>=app-portage/genup-1.0.14
	>=app-shells/bash-4.0"

src_install() {
	exeinto /etc/cron.weekly
	newexe "${FILESDIR}/cron.weekly_genup-2" "genup"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "A cron.weekly job has been created for genup; see"
		elog "${ROOT%/}/etc/cron.weekly/genup"
		elog "Please edit this as you wish (for example, to have"
		elog "the genup log file mailed to you upon completion)."
	fi
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]]; then
		# pure uninstall, but is the cronjob still there?
		if [ -f "${ROOT%/}/etc/cron.weekly/genup" ]; then
			ewarn "The file ${ROOT%/}/etc/cron.weekly/genup has not yet been removed,"
			ewarn "because you have manually edited it, so the weekly genup cron job"
			ewarn "is still active."
			ewarn "Please delete this file manually now."
		fi
	fi
}
