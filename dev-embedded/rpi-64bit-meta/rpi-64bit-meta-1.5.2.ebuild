# Copyright (c) 2017-9 sakaki <sakaki@deciban.com>
# License: GPL v3+
# NO WARRANTY

EAPI=6

DESCRIPTION="Baseline packages for the gentoo-on-rpi-64bit image"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-rpi-64bit"
SRC_URI=""

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~arm64"
IUSE="+boot-fw +kernel-bin -porthash +weekly-genup +innercore +core +xfce pitop apps"
REQUIRED_USE="
	core? ( innercore )
	xfce? ( core )
	pitop? ( xfce )
	apps? ( xfce )"

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND="
	>=sys-apps/openrc-0.42.1-r2[swclock-fix(-)]
	>=app-shells/bash-5.0"
# pi3multiboot flag pulls in matching bcmrpi3-kernel{,-bis}-bin package also
RDEPEND="
	${DEPEND}
	!dev-embedded/rpi3-64bit-meta
	kernel-bin? (
		boot-fw? (
			|| (
				>=sys-kernel/bcm2711-kernel-bin-4.19.67.20190827[with-matching-boot-fw(-),pitop(-)?,pi3multiboot]
				>=sys-kernel/bcm2711-kernel-bis-bin-4.19.67.20190827[with-matching-boot-fw(-),pitop(-)?,pi3multiboot]
			)
		)
		!boot-fw? (
			|| (
				>=sys-kernel/bcm2711-kernel-bin-4.19.67.20190827[-with-matching-boot-fw(-),pi3multiboot]
				>=sys-kernel/bcm2711-kernel-bis-bin-4.19.67.20190827[-with-matching-boot-fw(-),pi3multiboot]
			)
		)
	)
	!kernel-bin? (
		boot-fw? (
			>=sys-boot/rpi3-64bit-firmware-1.20190819[pitop(-)?,dtbo(+)]
		)
		!boot-fw? (
			!sys-boot/rpi3-64bit-firmware
		)
	)
	>=net-wireless/rpi3-bluetooth-1.1-r6
	>=sys-apps/rpi3-init-scripts-1.1.5
	>=sys-apps/rpi3-ondemand-cpufreq-1.1.1
	>=sys-firmware/b43-firmware-5.100.138
	>=sys-firmware/bluez-firmware-1.2
	>=sys-firmware/brcm43430-firmware-20190812
	porthash? (
		<sys-apps/portage-2.3.79
		>=app-portage/rpi3-check-porthash-1.0.0-r3
	)
	!porthash? (
		!app-portage/rpi3-check-porthash
		>=sys-apps/portage-2.3.79
	)
	weekly-genup? ( >=app-portage/weekly-genup-1.1.1-r2 )
	!weekly-genup? ( !app-portage/weekly-genup )
	innercore? (
		>=app-admin/logrotate-3.15.1
		>=app-admin/sudo-1.8.29-r2
		>=app-admin/syslog-ng-3.24.1
		>=app-crypt/gnupg-2.2.17
		>=app-editors/nano-4.5
		>=app-portage/eix-0.33.8
		>=app-portage/euses-2.5.9
		>=app-portage/gentoolkit-0.4.6
		>=app-portage/genup-1.0.24
		>=app-portage/mirrorselect-2.2.6-r1
		>=app-portage/showem-1.0.3
		>=app-text/dos2unix-7.4.1
		>=dev-embedded/rpi4-eeprom-updater-2.3.1
		>=dev-libs/elfutils-0.177
		>=dev-vcs/git-2.24.0
		>=media-libs/raspberrypi-userland-1.20191025-r1
		>=media-sound/alsa-tools-1.1.7
		>=media-sound/pulseaudio-13.0-r1[rpi-deglitch(-)]
		>=net-fs/nfs-utils-2.4.1-r3
		>=net-misc/bridge-utils-1.6
		>=net-misc/chrony-3.5-r2
		>=net-misc/dhcpcd-8.1.2
		>=net-misc/rpi3-ethfix-1.0.0-r1
		>=net-wireless/iw-5.3
		|| ( >=sys-apps/util-linux-2.34-r2 >=net-wireless/rfkill-0.5-r1 )
		>=net-wireless/rpi3-wifi-regdom-1.1
		>=net-wireless/wireless-tools-30_pre9
		>=net-wireless/wpa_supplicant-2.9-r1
		>=sys-apps/file-5.37-r1
		>=sys-apps/mlocate-0.26-r2
		>=sys-apps/rpi-gpio-1.0.0
		>=sys-apps/rpi-i2c-1.0.0
		>=sys-apps/rpi-onetime-startup-1.0.0
		>=sys-apps/rpi-serial-1.0.0
		>=sys-apps/rpi-spi-1.0.0
		>=sys-apps/rpi-video-1.0.0
		>=sys-apps/rpi3-expand-swap-1.0-r4
		>=sys-apps/rpi3-zswap-1.0-r1
		>=sys-apps/rng-tools-6.8
		>=sys-apps/usbutils-012
		>=sys-boot/rpi3-boot-config-1.0.8[pitop(-)?]
		>=sys-devel/distcc-3.3.3
		>=sys-fs/btrfs-progs-5.3.1
		>=sys-fs/dosfstools-4.1
		>=sys-fs/eudev-3.2.9
		>=sys-fs/f2fs-tools-1.13.0
		>=sys-fs/fuse-2.9.9-r1
		>=sys-fs/multipath-tools-0.8.3
		>=sys-process/cronie-1.5.5
		dev-lang/python:3.7[pgo(-)]
	)
	core? (
		>=app-arch/lzop-1.04
		>=app-editors/vim-8.1.0648
		>=app-editors/vim-core-8.1.0648
		>=app-misc/screen-4.7.0
		>=app-portage/porthash-1.0.8
		>=app-text/psutils-1.17-r3
		>=dev-embedded/wiringpi-2.44-r7
		>=dev-lang/go-1.13.4
		>=dev-libs/pigpio-71
		>=dev-python/pip-10.0.1
		>=dev-tcltk/expect-5.45.4
		>=dev-util/strace-5.3
		>=mail-client/mailx-8.1.2.20160123
		>=mail-client/mailx-support-20060102-r2
		>=net-analyzer/iptraf-ng-1.1.4-r3
		>=net-analyzer/nmap-7.80
		>=net-analyzer/tcpdump-4.9.3
		>=net-dialup/lrzsz-0.12.20-r4
		>=net-fs/samba-4.11.2
		>=net-irc/irssi-1.2.2
		>=net-misc/iperf-3.7
		>=net-misc/keychain-2.8.5
		>=net-misc/networkmanager-1.18.4-r1
		>=net-vpn/networkmanager-openvpn-1.8.10
		>=net-vpn/openvpn-2.4.7-r1
		>=sys-apps/ack-3.0.0
		>=sys-apps/coreboot-utils-4.6
		>=sys-apps/ethtool-5.3
		>=sys-apps/flashrom-1.0
		>=sys-apps/hdparm-9.58
		>=sys-apps/i2c-tools-4.1-r1
		>=sys-apps/me_cleaner-1.2
		>=sys-apps/smartmontools-7.0-r1
		>=sys-devel/clang-8.0.1
		>=sys-fs/ncdu-1.14.1
		>=sys-fs/zerofree-1.0.4
		>=sys-power/powertop-2.10
		>=sys-process/htop-2.2.0
		>=sys-process/iotop-0.6
	)
	xfce? (
		>=app-arch/xarchiver-0.5.4.14
		>=app-accessibility/onboard-1.4.1
		>=app-emulation/qemu-4.1.0
		>=app-misc/mc-4.8.23-r1
		>=app-office/orage-4.12.1-r1
		>=media-fonts/cantarell-0.111
		>=media-fonts/croscorefonts-1.31.0
		>=media-fonts/fontawesome-5.11.2
		>=media-fonts/libertine-5.3.0.20120702-r3
		>=media-fonts/ttf-bitstream-vera-1.10-r3
		>=media-libs/gst-plugins-bad-1.14.5
		>=media-libs/mesa-19.2.3-r1[rpi-v3d(-)]
		>=media-sound/pavucontrol-4.0
		>=media-tv/v4l-utils-1.16.6
		>=media-video/ffmpeg-4.2.1-r1[v4l2m2m-fix(-)]
		>=media-video/pi-ffcam-1.0.5
		>=media-video/pi-ffplay-1.0.6
		>=net-misc/tigervnc-1.9.0-r1
		>=net-misc/xorgxrdp-0.2.8
		>=net-wireless/blueman-2.0.4-r1
		>=sci-calculators/qalculate-gtk-3.2.0-r1
		>=sci-calculators/speedcrunch-0.12.0
		>=sys-apps/firejail-0.9.60-r1
		>=sys-apps/pyconfig_gen-1.1.7
		>=sys-block/gparted-0.33.0
		>=x11-apps/mesa-progs-8.4.0
		>=x11-apps/xclock-1.0.9
		>=x11-apps/xdm-1.1.12
		>=x11-apps/xev-1.2.3
		>=x11-apps/xmodmap-1.0.10
		>=x11-apps/xsetroot-1.1.2
		>=x11-base/xorg-server-1.20.5
		>=x11-misc/lightdm-1.30.0
		>=x11-misc/lightdm-gtk-greeter-2.0.6
		>=x11-misc/rpi3-safecompositor-1.0.3
		>=x11-misc/rpi3-safecursor-1.0.1
		>=x11-misc/twofing-0.1.2-r2
		>=x11-misc/xdiskusage-1.51
		>=x11-terms/xfce4-terminal-0.8.8
		>=x11-terms/xterm-350
		>=x11-themes/gnome-icon-theme-3.12.0-r1
		>=xfce-base/xfce4-meta-4.12-r1
		>=xfce-extra/thunar-archive-plugin-0.4.0
		>=xfce-extra/thunar-volman-0.9.5
		>=xfce-extra/tumbler-0.2.7
		>=xfce-extra/xfce4-alsa-plugin-0.1.1
		>=xfce-extra/xfce4-cpufreq-plugin-1.2.1
		>=xfce-extra/xfce4-cpugraph-plugin-1.0.5-r3
		>=xfce-extra/xfce4-fixups-rpi3-1.0.4
		>=xfce-extra/xfce4-indicator-plugin-2.3.3-r2
		>=xfce-extra/xfce4-mixer-4.99.0-r1
		>=xfce-extra/xfce4-noblank-1.0.0-r2
		>=xfce-extra/xfce4-notes-plugin-1.8.1-r3
		>=xfce-extra/xfce4-power-manager-1.6.5
		>=xfce-extra/xfce4-screenshooter-1.9.7
		>=xfce-extra/xfce4-systemload-plugin-1.2.3
		>=xfce-extra/xfce4-taskmanager-1.2.2
	)
	pitop? (
		>=dev-embedded/pitop-speaker-1.1.0.1
		>=sys-apps/pitop-poweroff-1.0.2-r5
		>=xfce-extra/xfce4-battery-plugin-1.1.0-r2[pitop]
		>=xfce-extra/xfce4-keycuts-pitop-1.0.2
	)
	apps? (
		>=app-arch/p7zip-16.02-r4
		>=app-crypt/seahorse-3.32.2
		>=app-editors/emacs-26.3-r1
		>=app-editors/mousepad-0.4.2
		>=app-office/abiword-3.0.2-r2
		>=app-office/libreoffice-6.3.3.2
		>=app-office/libreoffice-l10n-6.3.3.2
		>=app-portage/porthole-0.6.1-r6
		>=app-text/evince-3.32.1
		>=dev-util/meld-3.20.1
		>=mail-client/claws-mail-3.17.4
		>=mail-client/thunderbird-68.2.2-r1
		>=media-gfx/fotoxx-19.13
		>=media-gfx/gimp-2.10.12
		>=media-gfx/ristretto-0.10.0
		>=media-sound/clementine-1.3.1_p20191004
		>=media-sound/mpc-0.32
		>=media-sound/mpd-0.21.16-r1
		>=media-tv/kodi-18.4
		>=media-video/mplayer-1.3.0-r5
		>=media-video/mpv-0.30.0
		>=media-video/smplayer-19.10.2
		>=media-video/vlc-3.0.8
		>=net-irc/hexchat-2.14.2
		>=net-p2p/transmission-2.94-r1
		>=sys-apps/gnome-disk-utility-3.32.1
		>=sys-devel/portage-distccmon-gui-1.1
		>=www-client/chromium-78.0.3904.50-r2
		>=www-client/firefox-70.0.1
		>=www-client/links-2.18
		dev-java/icedtea:8
	)
"

src_install() {
	# basic framework file to enable / disable USE flags for this package
	insinto "/etc/portage/package.use/"
	newins "${FILESDIR}/package.use_${PN}-2" "${PN}"
}

pkg_postinst() {
	# ensure we have at least a system JVM set (if javac installed)
	if [ -e /usr/bin/javac ] && ! /usr/bin/javac -version &>/dev/null; then
		if eselect java-vm set system 1 &>/dev/null; then
			ewarn "Your JVM setup is now as follows:"
			ewarn "$(eselect java-vm show)"
			ewarn "Please modify (using eselect java-vm set ...) if incorrect"
		fi
	fi
	# migrate to appropriate sync-uri automatically, and force a sync
	# next time if we do, by deleting /usr/portage/metadata/timestamp.chk
	# (this is to ensure repo.hash{,.asc} gets added or removed, as
	# required)
	local RCONPATH="${ROOT%/}/etc/portage/repos.conf/gentoo.conf"
	if [ -e "${RCONPATH}" ]; then
		if use porthash && grep -q 'rsync://isshoni.org/gentoo-portage-pi64-gem$' "${RCONPATH}"; then
			sed -i 's#rsync://isshoni.org/gentoo-portage-pi64-gem$#rsync://isshoni.org/gentoo-portage-pi64#' "${RCONPATH}"
			rm -fv "${ROOT%/}/usr/portage/metadata/timestamp.chk"
			ewarn "This install has substituted:"
			ewarn " rsync://isshoni.org/gentoo-portage-pi64"
			ewarn "in place of:"
			ewarn " rsync://isshoni.org/gentoo-portage-pi64-gem"
			ewarn "as your gentoo repo's sync-uri"
			ewarn "in ${RCONPATH}."
			ewarn "The timestamp.chk file has also been deleted, to force"
			ewarn "this repo to sync next time you run genup."
		elif grep -q 'rsync://isshoni.org/gentoo-portage-pi64$' "${RCONPATH}"; then
			sed -i 's#rsync://isshoni.org/gentoo-portage-pi64$#rsync://isshoni.org/gentoo-portage-pi64-gem#' "${RCONPATH}"
			rm -fv "${ROOT%/}/usr/portage/metadata/timestamp.chk"
			ewarn "This install has substituted:"
			ewarn " rsync://isshoni.org/gentoo-portage-pi64-gem"
			ewarn "in place of:"
			ewarn " rsync://isshoni.org/gentoo-portage-pi64"
			ewarn "as your gentoo repo's sync-uri"
			ewarn "in ${RCONPATH}"
			ewarn "The timestamp.chk file has also been deleted, to force"
			ewarn "this repo to sync next time you run genup."
			rm -fv "${ROOT%/}/usr/portage"{,/local}"/repo.hash"{,.asc}
			ewarn "Any repo.hash{,.asc} files have also been deleted."
		fi
	else
		if use porthash; then
			ewarn "Please ensure you are using the following gentoo sync-uri:"
			ewarn "rsync://isshoni.org/gentoo-portage-pi64"
		fi
		# otherwise assume user knows what they are doing and is using the
		# main gentoo repo or similar
	fi
}
