# genpi64-overlay
Gentoo overlay (ebuild repository) for the Raspberry Pi 3 Model B and B+, and Raspberry Pi 4 Model B. Used by my bootable [`gentoo-on-rpi-64bit`](https://github.com/sakaki-/gentoo-on-rpi-64bit) image.

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/raspberrypi/pi4/Raspberry_Pi_3_B_and_B_plus_and_4_B.jpg" alt="RPi 3 B/B+ and 4B" width="200px" align="right"/>

> NB: this repository has been renamed, from `rpi3-overlay` to `genpi64-overlay`, to reflect its applicability to the new Pi4.

## List of ebuilds

The overlay provides the following ebuilds:

### Metapackage ebuilds

* **dev-embedded/rpi3-64bit-meta**

   This is a convenience metapackage, which you can `emerge` to pull in the appropriate set of RPi3-specific packages (described below) from the overlay, when constructing (or updating) a system patterned after that in my [`gentoo-on-rpi3-64bit`](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image. It is customized via the following USE flags:<a name="meta_use_flags"></a>
   
   | USE flag | Default? | Effect |
   | -------- | --------:| ------:|
   | `boot-fw` | Yes | Pull in the /boot firmware, configs and bootloader. |
   | `kernel-bin` | Yes | Pull in the `bcmrpi3-kernel-bin` binary kernel package. |
   | `porthash` | No | Pull in repo signature checker, for isshoni.org `rsync`. |
   |  `weekly-genup` | Yes | Pull in `cron.weekly` script, to run `genup` automatically. |
   |  `core` | Yes | Pull in core system packages for image (`sudo` etc.). |
   |  `xfce` | Yes | Pull in packages for baseline Xfce4 system. Requires `core`. |
   |  `pitop` | No | Pull in Pi-Top support packages (NB most users **won't** want this). Requires `xfce`. |
   |  `apps` | No | Pull in baseline desktop apps (`libreoffice` etc). Requires `xfce`. |



### Ebuilds related to the [`gentoo-on-rpi3-64bit`](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image

* **sys-firmware/brcm43430-firmware** [upstream](https://github.com/RPi-Distro/firmware-nonfree)
  * Just provides a configuration file (`brcmfmac43430-sdio.txt`) that is required for the RPi3's integrated WiFi (the main firmware is provided already, by [`sys-kernel/linux-firmware`](http://packages.gentoo.org/package/sys-kernel/linux-firmware)). Now also provides the equivalent file `brcmfmac43455-sdio.txt`, for use with the RPi3 B+'s new [dual-band WiFi](https://www.raspberrypi.com.tw/tag/bcm2837/) setup (Cypress CYW43455), plus the `brcmfmac43455-sdio.clm_blob`.

* **sys-firmware/bcm4340a1-firmware** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides firmware (`/etc/firmware/BCM43430A1.hcd`) for the RPi3's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux. Required by `net-wireless/rpi3-bluetooth` package (see below).

* **net-wireless/rpi3-bluetooth** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides a startup service and `udev` rule for the RPi3's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux.

* **net-wireless/rpi3-wifi-regdom** Provides a simple service to set the WiFi regulatory domain; the value set may be modified by editing the file `/etc/conf.d/rpi3-wifi-regdom`.

* **sys-devel/portage-distccmon-gui**
  * Desktop file (and wrapper) to view Portage jobs with `distccmon-gui` (provided your user is a member of the `portage` group).

* **sys-kernel/bcmrpi3-kernel-bin**
  * Provides ebuilds to install the available binary packages for the 64-bit `bcmrpi3_defconfig` Linux kernels (for the Raspberry Pi 3 model B and B+), which are updated weekly [here](https://github.com/sakaki-/bcmrpi3-kernel).

* **sys-kernel/bcmrpi3-kernel-bis-bin**
  * Provides ebuilds to install the available binary packages for (slightly tweaked versions of) the 64-bit `bcmrpi3_defconfig` Linux kernels (for the Raspberry Pi 3 model B and B+), which are updated weekly [here](https://github.com/sakaki-/bcmrpi3-kernel-bis).

* **media-libs/raspberrypi-userland**
  * Provides `raspberrypi-userland-1.20190114.ebuild`, a (restricted) 64-bit build (`-DARM64=ON`). Provides e.g. `vcgencmd` etc., but not e.g. the `MMAL` libraries, which are [currently unavailable in 64-bit](https://www.raspberrypi.org/forums/viewtopic.php?p=1433757#p1433757).

* **sys-apps/rpi3-init-scripts**
  * Provides a few simple init scripts for the [gentoo-on-rpi3-64bit](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image (to autoexpand the root partition on first boot, inhibit XVideo, setup cache usage appropriate for a low-memory environment etc.).

* **sys-apps/rpi3-ondemand-cpufreq**
  * Provides the `rpi3-ondemand` OpenRC `sysinit` service, to switch the RPi3 from its (`bcmrpi3_defconfig`) default `powersave` CPU frequency governor, to `ondemand`, for better performance.

* **x11-misc/rpi3-safecompositor**
  * Provides the `rpi3-safecompositor` OpenRC service, which turns off display compositing if a high pixel clock is detected (> 1.2175MHz, currently). This is because certain applications, for example LibreOffice v6 Draw and Impress, can cause the whole system to lock-up when used with compositing on under such conditions. As of version 1.0.1, _also_ inhibits compositing when used with the 4.19 kernel under 'true' kms mode (`vc4-kms-v3d`) as this can cause periodic 'stalling' of the display otherwise (`vc4-fkms-v3d` is unaffected).

* **x11-misc/rpi3-safecursor**
  * Provides the `rpi3-safecursor` OpenRC service, which will install a rule to force software cursor blitting (rather than the hardware default) if the user has not set `disable_overscan=1` in `config.txt`. (Required because hardware cursor blitting in the open-source vc4 driver does not always take account of the overscan 'bezel' correctly on HDMI TVs, resulting in an offset cursor.) The service no-ops with any >= 4.14.y kernel however (i.e., the 4.19.y currently supplied), as these have the fix [already committed](https://github.com/raspberrypi/linux/commit/81bbe80e7bebab6211c72bf0c0f81a4bc2370eab).

* **sys-boot/rpi3-64bit-firmware** [upstream](https://github.com/raspberrypi/firmware)
  * Provides the firmware and config files required in `/boot` to boot the RPi3 in 64-bit mode. Does not provide the kernel or DTBs (see `sys-kernel/bcmrpi3-kernel-bin`, above, for that). A weekly check is made to see if a new tag has been added to the official [`raspberrypi/firmware/boot`](https://github.com/raspberrypi/firmware/tree/master/boot) upstream, and, if so, a matching ebuild is automatically created here. With the `dtbo` USE flag off (as forced [by the profile](https://github.com/sakaki-/rpi3-overlay/blob/master/profiles/targets/rpi3/package.use/rpi3-64bit-firmware), currently), does _not_ provide or populate the `/boot/overlays` directory - this then being the responsibility of the binary kernel package.

* **dev-embedded/wiringpi** [upstream](http://wiringpi.com/)
  * Provides Gordon Henderson's `WiringPi`, a PIN based GPIO access library (with accompanying `gpio` utility).

* **xfce-extra/xfce4-fixups-rpi3**
  * Effects some useful new-user fixups for Xfce4 on the RPi3 (forcing compositing to sync to the vertical blank etc.). Installs an `/etc/xdg/autostart/xfce4-fixups-rpi3.desktop` entry.

* **xfce-extra/xfce4-keycuts-pitop**
  * Installs some simple keyboard shortcuts for the Pi-Top (an RPi3-based DIY laptop).

* **xfce-extra/xfce4-battery-plugin** [upstream](https://github.com/rricharz/pi-top-battery-status)
  * A modified version of the standard `xfce4-battery-plugin` gas gauge. It is patched with code from rricharz to query the status of the Pi-Top's battery over I2C; this code is activated by building with the `pitop` USE flag (NB - _only_ for use on Pi-Top systems).

* **sys-apps/pitop-poweroff**
  * Provides a simple OpenRC shutdown service, to ensure that the Pi-Top's onboard hub controller is properly powered off (NB - _only_ for use on Pi-Top systems).

* **sys-apps/rpi3-spidev**
  * Provides a `udev` rule for SPI access on the RPi3; ensures that the `/dev/spidevN.M` devices are read/write for all members of the `wheel` group, not just `root`.

* **sys-apps/rpi3-i2cdev**
  * Proves an OpenRC service and `udev` rule for I2C access on the RPi3. Ensures that the `i2c-dev` module is `modprobe`d, and that the `/dev/i2c-[0-9]` devices are read/write for all members of the `wheel` group, not just `root`.

* **dev-embedded/pitop-utils** [upstream](https://github.com/rricharz/pi-top-install)
  * Provides the `pt-poweroff` and `pt-brightness` `sbin` utilities for the Pi-Top (NB - _only_ for use on Pi-Top systems).

* **dev-embedded/pitop-speaker** [upstream](https://github.com/pi-top/pi-topSPEAKER)
  * Provides the `ptspeaker` Python 3 package and accompanying OpenRC service, to initialize pitopSPEAKER add-on-boards (NB - _only_ for use on Pi-Top systems). The init has been adapted from the original Debian package and does _not_ use `pt-peripherals-daemon`.

* **x11-misc/twofing** [upstream](http://plippo.de/p/twofing)
  * Provides the `twofing` daemon, which converts touchscreen gestures into mouse and keyboard events. Included primarily for use with the offical 7" RPi (1,2,3) touchscreen.

* **app-accessibility/onboard** [upstream](https://launchpad.net/onboard)
  * Provides a flexible onscreen keyboard. Again, included primarily for use with the offical 7" RPi (1,2,3) touchscreen. Adapted with thanks from original ebuild, [here](https://bitbucket.org/wjn/wjn-overlay).

* **sys-apps/qdiskusage** [upstream](http://www.qt-apps.org/content/show.php/QDiskUsage?content=107012)
  * Provides `qdiskusage-1.99.ebuild`, a dummy, as this has now been removed from the main Gentoo tree, and the local copy no longer builds, due to missing deps.

* **x11-themes/gnome-icon-theme** [upstream](https://www.gnome.org)
  * Provides `gnome-icon-theme-3.12.0-r1.ebuild`; this has been removed from the main Gentoo tree, but is still required for some icons on the image. 

* **xfce-extra/xfce4-notifyd** [upstream](https://goodies.xfce.org/projects/applications/xfce4-notifyd)
  * Provides `xfce4-notifyd-0.4.0.ebuild`; this has been removed from the main Gentoo tree, but is still used on the image. Upgrades masked because of message truncation, which causes problems with PIN notification during Bluetooth device setup. To be fixed / resolved.

* **xfce-extra/xfce4-indicator-plugin** [upstream](https://goodies.xfce.org/projects/panel-plugins/xfce4-indicator-plugin)
  * Provides `xfce4-indicator-plugin-2.3.3-r2.ebuild`; this has been removed from the main Gentoo tree, and the v2.3.4 is currently masked.

* **xfce-extra/xfc4-mixer** [upstream](http://softwarebakery.com/maato/volumeicon.html)
  * Provides `xfc4-mixer-4.99.0-r1`, a 'pseudo-package' replacing the original, treecleaned `xfce4-mixer` with the (broadly equivalent) `media-sound/volumeicon` package.

* **www-client/firefox** [upstream](http://www.mozilla.com/firefox)
  * Provides patched ebuilds for the full-scale `firefox` browser, as each variant generally has some issue preventing a straight compile on arm64 (see e.g. [here](https://forums.gentoo.org/viewtopic-p-8306684.html#8306684) and [here](https://forums.gentoo.org/viewtopic-p-8266770.html#8266770)).

* **sys-boot/rpi3-boot-config**
  * Provides the 'starter' configuration files `/boot/cmdline.txt` and `/boot/config.txt` (in both standard and Pi-Top trim).

* **net-wireless/blueman**
  * Provides `blueman-2.0.4-r1.ebuild`; this has been removed from the main Gentoo tree, but is in use on the image (until the current version proves stable, at which point it will be unmasked, and `blueman` will revert to using the main-tree ebuild).

* **net-misc/ethfix**
  * Provides an OpenRC service to workaround certain RPi3B+ Ethernet issues via `ethtool`.

* **app-office/orage** [upstream](https://git.xfce.org/apps/orage/)
  * Provides `orage-4.12.1-r1.ebuild`, patched for [bug 657542](https://bugs.gentoo.org/657542). Once this revbumps in the main Gentoo tree, `orage` should revert to using that version instead.

* **app-portage/rpi3-check-porthash**
  * Provides a [`porthash`](https://github.com/sakaki-/porthash) signed hash check for the [isshoni.org](https://isshoni.org) rsync gentoo ebuild repository, implemented as a `repo.postsync.d` hook. NB not used as of v1.3.0 of the image (although still included), as Gentoo's official `gemato` signature check is used instead; please see the release notes [here](https://github.com/sakaki-/gentoo-on-rpi3-64bit/releases/tag/v1.3.0).

* **xfce-extra/xfce4-noblank**
  * Provides an `/etc/xdg/autostart` script to prevent the `xscreensaver` blanking the screen, even when it is notionally 'off'.

* **www-client/chromium** [upstream](http://chromium.org/)
  * Provides a number of versions of the open-source browser `chromium`, capable of being built in a `bindist` compatible manner (by suppressing all software-based `h264` codec inclusions), and with `clang` build forced.

* **media-libs/raspberrypi-userland** [upstream](https://github.com/raspberrypi/userland)
  * Provides a (restricted) 64-bit build (`-DARM64=ON`) of `raspberrypi-userland`, for`vcgencmd` etc. The ebuild needs tidying, so please use with care ><

* **sys-apps/rpi3-zswap**
  * Provides a service to activate the `zswap` kernel facility to transparently compress, and cache in RAM, pages that are being evicted to swap. Can significantly improve responsiveness of the RPi3 when a number of large applications are open. Configured via `/etc/conf.d/rpi3-zswap`.

* **sys-apps/rpi3-expand-swap**
  * Provides a service to expand the default swapfile (`/var/cache/swap/swap1`) to 1,024MiB on first boot (after the root filesystem has been expanded), subject to sufficient space.

* **sys-apps/pyconfig_gen**
  * Provides a simple, PyQt5 dialog-based app, to allow the `/boot/config.txt` file to be edited in a structured manner, together with some support services (to revert the new config automatically, unless ratified upon reboot).

* **app-portage/weekly-genup**
  * Installs a simple cron.weekly script, to automate `genup`, and another, to run 'fixups' (small scripts to correct issues that may e.g. prevent correct `genup` operation etc.).

* **net-libs/nodejs** [upstream](https://nodejs.org/)
  * Provides `nodejs-9.11.2-r2`, a version that can work under `bindist`, by using the EC-patched `openssl` libraries.

* **net-libs/nghttp2
