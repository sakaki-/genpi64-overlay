# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

KEYWORDS="~arm64"

DESCRIPTION="Installs simple cron.weekly script, to automate genup"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi3-64bit"
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
	>=app-portage/genup-1.0.16
	>=app-shells/bash-4.0
	>=sys-devel/patch-2.7.6"

src_install() {
	exeinto /etc/cron.weekly
	newexe "${FILESDIR}/cron.weekly_genup-2" "genup"
	newexe "${FILESDIR}/cron.weekly_fixup-2" "fixup"
}

pkg_postinst() {
	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "A cron.weekly job has been created for genup; see"
		elog "${ROOT%/}/etc/cron.weekly/genup"
		elog "Please edit this as you wish (for example, to have"
		elog "the genup log file mailed to you upon completion)."
		elog "A cron.weekly job has been created to run 'fixup' scripts; see"
		elog "${ROOT%/}/etc/cron.weekly/fixup"
		elog "Please edit this as you wish (for example, to have"
		elog "the log file mailed to you upon completion)."
	fi
	if [[ "${ROOT}" == "/" ]]; then
		elog "Running fixups now, to ensure system clean"
		elog "(this is a one-off; the cron.weekly job is still active)."
		elog "Check /var/log/latest-fixup-run.log for output."
		/etc/cron.weekly/fixup
	fi
}

pkg_postrm() {
	if [[ -z "${REPLACED_BY_VERSION}" ]]; then
		# pure uninstall, but are any of the cronjobs still there?
		if [ -f "${ROOT%/}/etc/cron.weekly/genup" ]; then
			ewarn "The file ${ROOT%/}/etc/cron.weekly/genup has not yet been removed,"
			ewarn "because you have manually edited it, so the weekly genup cron job"
			ewarn "is still active."
			ewarn "Please delete this file manually now."
		fi
		if [ -f "${ROOT%/}/etc/cron.weekly/fixup" ]; then
			ewarn "The file ${ROOT%/}/etc/cron.weekly/fixup has not yet been removed,"
			ewarn "because you have manually edited it, so its weekly cron job"
			ewarn "is still active."
			ewarn "Please delete this file manually now."
		fi
	fi
}
