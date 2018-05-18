# rpi3-overlay
Gentoo overlay (ebuild repository) for the Raspberry Pi 3 Model B and B+. Used by my bootable [`gentoo-on-rpi3-64bit`](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image.

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
   | `porthash` | Yes | Pull in repo signature checker, for isshoni.org `rsync`. |
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
  * Desktop file (and wrapper) to view Portage jobs with `distccmon-gui` (provided your user is a member of the `portage` group). Currently installed on the image, but _not_ controlled by the `rpi3-64bit-meta` metapackage.
* **sys-kernel/bcmrpi3-kernel-bin**
  * Provides ebuilds to install the available binary packages for the 64-bit `bcmrpi3_defconfig` Linux kernels (for the Raspberry Pi 3 model B and B+), which are updated weekly [here](https://github.com/sakaki-/bcmrpi3-kernel).
* **media-libs/raspberrypi-userland**
  * Provides `raspberrypi-userland-1.20170721-r1.ebuild`, a (restricted) 64-bit build (`-DARM64=ON`). Not currently installed on the image, or controlled by the `rpi3-64bit-meta` metapackage. Provides e.g. `vcgencmd` etc., but the ebuild needs tidying, so please use with care ><
* **sys-apps/rpi3-init-scripts**
  * Provides a few simple init scripts for the [gentoo-on-rpi3-64bit](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image (to autoexpand the root partition on first boot, inhibit XVideo etc.).
* **sys-apps/rpi3-ondemand-cpufreq**
  * Provides the `rpi3-ondemand` OpenRC `sysinit` service, to switch the RPi3 from its (`bcmrpi3_defconfig`) default `powersave` CPU frequency governor, to `ondemand`, for better performance.
* **x11-misc/rpi3-safecursor**
  * Provides the `rpi3-safecursor` OpenRC service, which will install a rule to force software cursor blitting (rather than the hardware default) if the user has not set `disable_overscan=1` in `config.txt`. (Required because hardware cursor blitting in the open-source vc4 driver does not always take account of the overscan 'bezel' correctly on HDMI TVs, resulting in an offset cursor.) The service no-ops with the supplied 4.14.y kernel however, as this has a fix [already committed](https://github.com/raspberrypi/linux/commit/81bbe80e7bebab6211c72bf0c0f81a4bc2370eab).
* **app-portage/rpi3-check-porthash**
  * Provides a [`porthash`](https://github.com/sakaki-/porthash) signed hash check for the [isshoni.org](https://isshoni.org) rsync gentoo ebuild repository, implemented as a `repo.postsync.d` hook.
* **sys-boot/rpi3-64bit-firmware** [upstream](https://github.com/raspberrypi/firmware)
  * Provides the firmware and config files required in `/boot` to boot the RPi3 in 64-bit mode. Does not provide the kernel or DTBs (see `sys-kernel/bcmrpi3-kernel-bin`, above, for that). A weekly check is made to see if a new tag has been added to the official [`raspberrypi/firmware/boot`](https://github.com/raspberrypi/firmware/tree/master/boot) upstream, and, if so, a matching ebuild is automatically created here.
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
* **media-tv/kodi** [upstream](https://github.com/xbmc/xbmc)
  * Provides `kodi-17.4_rc1.ebuild`; adapted from the version in the main Gentoo tree (with `~arm64` keyworded, and the dependency list modified to avoid relying on MS fonts with a non-free licence (the remaining deps and the package itself being FOSS licensed)).
* **sys-apps/qdiskusage** [upstream](http://www.qt-apps.org/content/show.php/QDiskUsage?content=107012)
  * Provides `qdiskusage-1.0.4.ebuild`, no longer in the main Gentoo tree.
* **x11-themes/gnome-icon-theme** [upstream](https://www.gnome.org)
  * Provides `gnome-icon-theme-3.12.0-r1.ebuild`; this has been removed from the main Gentoo tree, but is still required for some icons on the image. 
* **x11-base/xorg-server** [upstream](https://www.x.org/wiki/)
  * Provides `xorg-server-1.19.6-r1.ebuild`; this has been removed from the main Gentoo tree, but is still the current main rev, and in use on the image.
* **xfce-extra/xfce4-notifyd** [upstream](https://goodies.xfce.org/projects/applications/xfce4-notifyd)
  * Provides `xfce4-notifyd-0.4.0.ebuild`; this has been removed from the main Gentoo tree, but is still used on the image. Upgrades masked because of message truncation, which causes problems with PIN notification during Bluetooth device setup. To be fixed / resolved soon.
* **xfce-extra/xfce4-indicator-plugin** [upstream](https://goodies.xfce.org/projects/panel-plugins/xfce4-indicator-plugin)
  * Provides `xfce4-indicator-plugin-2.3.3-r2.ebuild`; this has been removed from the main Gentoo tree, and the v2.3.4 is currently masked.

## Other ebuilds

* **dev-lang/rust** [upstream](http://www.rust-lang.org/)
  * Provides `rust-1.19.0-r1.ebuild`; adapted from the Gentoo tree version to build under `arm64`; build system also respects the `nativeonly` USE flag and user `MAKEOPTS` for efficiency (thanks to [NeddySeagoon](https://github.com/sakaki-/rpi3-overlay/commit/3abb46bcff04d9b66c8b3c50d309f199606ac0fa##commitcomment-23709642)). The system-programming language `dev-lang/rust` is a hard dependency for `www-client/firefox` versions 55 and above (as is `sys-devel/cargo`). However, as the (more modern) main Gentoo tree version now also builds, this is no longer necessary.
* **dev-util/cargo** [upstream](http://crates.io)
  * Provides `cargo-0.20.0.ebuild`, adapted from the Gentoo tree version to build under `arm64`. `dev-util/cargo` is the package manager for `dev-lang/rust`. However, as the (more modern) main Gentoo tree version now also builds, this is no longer necessary.

## Installation

As of version >= 2.2.16 of Portage, **rpi3-overlay** is best installed (on Gentoo) via the [new plug-in sync system](https://wiki.gentoo.org/wiki/Project:Portage/Sync). It will supply a repository named **rpi3**.

The following are short form instructions. If you haven't already installed **git**(1), do so first:

    # emerge --ask --verbose dev-vcs/git 

Next, create a custom `/etc/portage/repos.conf` entry for the **rpi3** overlay, so Portage knows what to do. Make sure that `/etc/portage/repos.conf` exists, and is a directory. Then, fire up your favourite editor:

    # nano -w /etc/portage/repos.conf/rpi3.conf

and put the following text in the file:
```ini
[rpi3]

# Overlay for Gentoo on the RPi3 SBC
# Maintainer: sakaki (sakaki@deciban.com)

location = /usr/local/portage/rpi3
sync-type = git
sync-uri = https://github.com/sakaki-/rpi3-overlay.git
priority = 100
auto-sync = yes
```

Then issue:

    # emaint sync --repo rpi3

If you are running on the stable branch by default, allow **~arm64** keyword files from this repository. Make sure that `/etc/portage/package.accept_keywords` exists, and is a directory. Then issue:

    # echo "*/*::rpi3 ~arm64" >> /etc/portage/package.accept_keywords/rpi3-repo
    
Now you can install packages from the overlay. For example:

    # emerge --ask --verbose sys-kernel/bcmrpi3-kernel-bin

## Maintainers

* [sakaki](mailto:sakaki@deciban.com)
