# genpi64-overlay
Gentoo overlay (ebuild repository) for the Raspberry Pi 3 Model B and B+, and Raspberry Pi 4 Model B. Used by my bootable [`gentoo-on-rpi3-64bit`](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image.

> NB: this repository has been renamed, from `rpi3-overlay` to `genpi64-overlay`, to reflect its applicability to the new Pi4.

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/raspberrypi/pi3/Raspberry_Pi_3_B_and_B_plus.jpg" alt="Raspberry Pi 3 B" width="250px" align="right"/>

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

* **net-libs/nghttp2** [upstream](https://nghttp2.org/)
  * Provides `ngtttp2-1.34.0-r2`, a version that can work under `bindist`, by using the EC-patched `openssl` libraries.

* **media-video/ffmpeg** [upstream](https://ffmpeg.org)
  * Provides `ffmpeg-4.1.1-r2.ebuild`; a version patched to work correctly with the RPi3's hardware video codecs and (optional) camera module.

* **media-video/pi-ffplay**
  * Provides a trivial video player app (based on `ffplay`) that uses the RPi3's hardware video codecs where possible.

* **media-video/pi-ffcam**
  * Provides a trivial live view app for the RPi3's (optional) camera module.

* **xfce-extra/xfce4-cpugraph-plugin** [upstream](https://goodies.xfce.org/projects/panel-plugins/xfce4-cpugraph-plugin)
  * Provides a version of this plugin that periodically completely redraws, as the original is subject to occasional display corruption.

## Other ebuilds

* **dev-lang/rust** [upstream](http://www.rust-lang.org/)
  * Provides `rust-1.19.0-r1.ebuild`; adapted from the Gentoo tree version to build under `arm64`; build system also respects the `nativeonly` USE flag and user `MAKEOPTS` for efficiency (thanks to [NeddySeagoon](https://github.com/sakaki-/rpi3-overlay/commit/3abb46bcff04d9b66c8b3c50d309f199606ac0fa##commitcomment-23709642)). The system-programming language `dev-lang/rust` is a hard dependency for `www-client/firefox` versions 55 and above (as is `sys-devel/cargo`). Also provides `rust-1.29.2.ebuild`. However, as the (more modern) main Gentoo tree version now also builds, these are no longer necessary.

* **virtual/rust** [upstream](http://www.rust-lang.org/)
  * Provides `rust-1.31.1-r1.ebuild`; adapted from the Gentoo tree version to fix a missing symlink that occurred during the transition to rust 'owning' the installation of `cargo`. As the transition has now happened (and more modern versions are in the Gentoo tree), this is no longer necessary.

* **dev-util/cargo** [upstream](http://crates.io)
  * Provides `cargo-0.20.0.ebuild`, adapted from the Gentoo tree version to build under `arm64`. `dev-util/cargo` is the package manager for `dev-lang/rust`. However, as `rust` has now taken over installation responsibility for `cargo`, this is no longer necessary.

* **x11-base/xorg-server** [upstream](https://www.x.org/wiki/)
  * Provides `xorg-server-1.19.6-r1.ebuild`; this has been removed from the main Gentoo tree. However, as the (more modern) main Gentoo tree version now also builds, this is no longer necessary.

* **app-office/libreoffice** [upstream](https://www.libreoffice.org)
  * Provides `libreoffice-5.4.4.2-r1.ebuild`, patched for [bug 641812](https://bugs.gentoo.org/641812). However, as the (more modern) main Gentoo tree version now also builds, this is no longer necessary.

* **dev-python/pyopenssl** [upstream](https://pypi.org/project/pyOpenSSL/)
  * Provides `pyopenssl-17.0.0`; this has been removed from the main Gentoo tree. However, now the ec workarounds for `dev-libs/openssl` are in use (making it `bindist` compatible), this legacy version is no longer required.

* **dev-libs/openssl** [upstream](https://www.openssl.org/)
  * Provides `openssl-1.0.2o-r6.ebuild`; with ec workaround patch for `bindist`. However, now the version in the main Gentoo tree also has this patch, this version is no longer required.

* **net-fs/nfs-utils** [upstream](http://linux-nfs.org/)
  * Provides `nfs-utils-2.1.1-r2.ebuild`; this has been removed from the main Gentoo tree. However, as the (more modern) main Gentoo tree version is now also usable, this is no longer necessary.

* **net-p2p/cpuminer-multi** [upstream](https://github.com/tpruvot/cpuminer-multi)
  * Provides `cpuminer-multi-1.3.3.ebuild`; a multi-threaded cryptocurrency CPU miner that builds on arm64. Not currently included on the image by default.

* **net-misc/m-minerd** [upstream](https://github.com/magi-project/m-cpuminer-v2)
  * Provides `m-minerd-2.4.ebuild`; a multi-threaded CPU pool miner for M7M/Magi (XMG) that builds on arm64. Not currently included on the image by default.

* **media-tv/kodi** [upstream](https://github.com/xbmc/xbmc)
  * Provides `kodi-17.4_rc1.ebuild`; adapted from the version in the main Gentoo tree (with `~arm64` keyworded, and the dependency list modified to avoid relying on MS fonts with a non-free licence (the remaining deps and the package itself being FOSS licensed)). As the main tree versions have now also dropped the dep, this is no longer necessary.

* **sys-apps/portage** [upstream](https://wiki.gentoo.org/wiki/Project:Portage)
  * Provides `portage-2.3.48`; this has been removed from the main Gentoo tree, but is still required to ensure those upgrading the image from a pre-1.3.0 release can do so successfully (with legacy `porthash` authentication); also `portage-2.3.52-r1` (another legacy requirement). The image however currently uses the main tree version (which is more up-to-date).

* **dev-lang/pony** [upstream](https://www.ponylang.io/)
  * Provides `pony-0.25.0{,-r1}.ebuild`; an open-source, object-oriented, actor-model, programming language. Not currently included on the image by default.

* **net-misc/xrdp** [upstream](https://github.com/neutrinolabs/xrdp)
  * Provides `xrdp-0.9.8e.ebuild`; an open-source Remote Desktop Protocol server. Not currently included on the image by default.

* **net-misc/xorgxrdp** [upstream](https://github.com/neutrinolabs/xrdp)
  * Provides `xorgxrdp-0.2.8.ebuild`; Xorg drivers for `xrdp`. Not currently included on the image by default.

* **dev-php/pthreads** [upstream](https://github.com/krakjoe/pthreads)
  * Provides `pthreads-3.2.0.ebuild`; a threading extension for PHP. Not currently included on the image by default.

## Custom profile

The overlay also provides a custom profile, [`rpi3:default/linux/arm64/17.0/desktop/rpi3`](https://github.com/sakaki-/rpi3-overlay/tree/master/profiles/targets/rpi3), for use on the [`gentoo-on-rpi3-64bit`](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image. For futher details, please see [these notes](https://github.com/sakaki-/gentoo-on-rpi3-64bit#profile).

## Installation

As of version >= 2.2.16 of Portage, **rpi3-overlay** is best installed (on Gentoo) via the [new plug-in sync system](https://wiki.gentoo.org/wiki/Project:Portage/Sync). It will supply a repository named **rpi3**.

The following are short form instructions. If you haven't already installed **git**(1), do so first:

    # emerge --ask --verbose dev-vcs/git 

Next, create a custom `/etc/portage/repos.conf` entry for the **genpi64** overlay, so Portage knows what to do. Make sure that `/etc/portage/repos.conf` exists, and is a directory. Then, fire up your favourite editor:

    # nano -w /etc/portage/repos.conf/genpi64.conf

and put the following text in the file:
```ini
[genpi64]

# Overlay for 64-bit Gentoo on the RPi3 and RPi4 SBCs
# Maintainer: sakaki (sakaki@deciban.com)

location = /usr/local/portage/genpi64
sync-type = git
sync-uri = https://github.com/sakaki-/genpi64-overlay.git
priority = 100
auto-sync = yes
```

Then issue:

    # emaint sync --repo genpi64

If you are running on the stable branch by default, allow **~arm64** keyword files from this repository. Make sure that `/etc/portage/package.accept_keywords` exists, and is a directory. Then issue:

    # echo "*/*::genpi64 ~arm64" >> /etc/portage/package.accept_keywords/genpi64-repo
    
Now you can install packages from the overlay. For example:

    # emerge --ask --verbose sys-kernel/bcm2711-kernel-bin

## Maintainers

* [sakaki](mailto:sakaki@deciban.com)

