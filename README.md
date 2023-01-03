# genpi64-overlay

Gentoo overlay (ebuild repository) for the Raspberry Pi 3 Model B and B+, and Raspberry Pi 4 Model B. Used by [`GenPi64`](https://github.com/GenPi64/gentoo-on-rpi-64bit) image.

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/raspberrypi/pi4/Raspberry_Pi_3_B_and_B_plus_and_4_B.jpg" alt="RPi 3 B/B+ and 4B" width="200px" align="right"/>

> NB: this repository has been renamed, from `rpi3-overlay` to `genpi64-overlay`, to reflect its applicability to the new Pi4.

## <a id="list_of_ebuilds"></a>List of ebuilds

The overlay provides the following ebuilds:


### Metapackage ebuilds
### **No Longer Used!**
Instead of a meta package, select the profile and sets you want.
* **dev-embedded/rpi-64bit-meta**

  * This is the main `gentoo-on-rpi-64bit` metapackage - its version matches that of the image release. It replaces the prior `gentoo-on-rpi3-64bit` metapackage. The features it pulls in (via other ebuilds) can be customized via the following USE flags (edit via `/etc/portage/package.use/rpi-64bit-meta`):<a name="meta_use_flags"></a>
   
     | USE flag | Default? | Effect |
     | -------- | --------:| ------:|
     | `boot-fw` | Yes | Pull in the /boot firmware, configs and bootloader. |
     | `kernel-bin` | Yes | Pull in the `bcm{2711,rpi3}-kernel<-bis>-bin` binary kernel package. |
     |  `weekly-genup` | Yes | Pull in `cron.weekly` script, to run `genup` automatically. |
     | `innercore` | Yes | Pull in essential system packages for image (RPi initscripts etc.) |
     |  `core` | Yes | Pull in main packages for image (`clang` etc.). Requires `innercore`. |
     |  `xfce` | Yes | Pull in packages for baseline Xfce4 system. Requires `core`. |
     |  `pitop` | No | Pull in Pi-Top packages (NB most users **won't** want this). Requires `xfce`. |
     |  `apps` | No | Pull in baseline desktop apps (`libreoffice` etc). Requires `xfce`. |


### Ebuilds related to the [`gentoo-on-rpi-64bit`](https://github.com/GenPi64/gentoo-on-rpi-64bit) image

> Note that for historical reasons, many of these ebuilds may contain `rpi3-` in the name, but yet still be applicable on the RPi4.
* **app-accessibility/onboard** [upstream](https://launchpad.net/onboard)
  * Provides a flexible onscreen keyboard. Included primarily for use with the official 7" RPi touchscreen. Adapted with thanks from original ebuild, [here](https://bitbucket.org/wjn/wjn-overlay).

* **app-portage/weekly-genup**
  * Installs a simple cron.weekly script, to automate `genup`, and another, to run 'fixups' (small scripts to correct issues that may e.g. prevent correct `genup` operation, effect upstream file hierarchy migrations etc.).

* **net-misc/rpi3-ethfix**
  * Effects some simple Ethernet workarounds (using `ethtool`) for the RPi3B+. It has no effect on the RPi3B or RPi4B.

* **net-wireless/rpi3-bluetooth** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides a startup service and `udev` rule for the RPi3/4's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux.

* **net-wireless/rpi3-wifi-regdom** Provides a simple service to set the WiFi regulatory domain; the value set may be modified by editing the file `/etc/conf.d/rpi3-wifi-regdom`.

* **sys-apps/pyconfig_gen** [upstream](https://github.com/GenPi64/pyconfig_gen)
  * Provides a simple, PyQt5 dialog-based app, to allow the `/boot/config.txt` file to be edited in a structured manner, together with some support services (to revert the new config automatically, unless ratified upon reboot).

* **sys-apps/rpi-gpio**
  * Sets up a `udev` rule to allow GPIO access (on the RPi3/4) for members of the `gpio` group.  On installation, all current members of `wheel` are automatically made members of `gpio`. Now installed for all users of the `rpi-64bit-meta` package (with `innercore` USE).

* **sys-apps/rpi-i2c**
  * Like `rpi3-i2cdev` (see below), sets up a `udev` rule to allow I2C access (on the RPi3/4) for members of the `i2c` group, and ensures that the `i2c_dev` module is `modprobe`d. On installation, all current members of `wheel` are automatically made members of `i2c` (to allow for straightforward transition from `rpi3-spidev`). Now installed for all users of the `rpi-64bit-meta` package (with `innercore` USE).

* **sys-apps/rpi-onetime-startup**
  * Provides a startup service which (having first disabled itself from running again) executes, as root, the script `/boot/startup.sh`, if present. This script can be used to e.g., set up initial WiFi networking on a headless system, thereby allowing an `ssh` connection to be established. The provided template `/boot/startup.sh` script contains several (commented out) examples of NetworkManager configuration.

* **sys-apps/rpi-serial**
  * Provides a `udev` rule to create appropriate serial port device aliases at `/dev/serial0` and/or `/dev/serial1` (using code borrowed from Raspbian).

* **sys-apps/rpi-spi**
  * Like `rpi3-spidev` (see below), sets up a `udev` rule to allow SPI access (on the RPi3/4) for members of the `spi` group. On installation, all current members of `wheel` are automatically made members of `spi` (to allow for straightforward transition from `rpi3-spidev`). Now installed for all users of the `rpi-64bit-meta` package (with `innercore` USE).

* **sys-apps/rpi-video**
  * Provides a `udev` rule to allow members of the `video` group access to `/dev/rpivid*` and `/dev/argon*` devices (using code borrowed from Raspbian).

* **sys-apps/rpi3-i2cdev**
  * Provides an OpenRC service and `udev` rule for I2C access on the RPi3/4. Ensures that the `i2c-dev` module is `modprobe`d, and that the `/dev/i2c-[0-9]` devices are read/write for all members of the `wheel` group, not just `root`. Originally installed by the `pitop` USE flag on `rpi-64bit-meta`, it has since been superseded by `rpi-i2c`, above.

* **sys-apps/rpi3-init-scripts**
  * Provides a few simple init scripts for the [gentoo-on-rpi-64bit](https://github.com/GenPi64/gentoo-on-rpi-64bit) image (to autoexpand the root partition on first boot, inhibit XVideo, setup cache usage appropriate for a low-memory environment etc.).

* **sys-apps/rpi3-ondemand-cpufreq**
  * Provides the `rpi3-ondemand` OpenRC `sysinit` service, to switch the RPi3 and RPi4 from its (`bcmrpi3_defconfig` and `bcm2711_defconfig`) default `powersave` CPU frequency governor, to `ondemand`, for better performance.

* **sys-apps/rpi3-spidev**
  * Provides a `udev` rule for SPI access on the RPi3; ensures that the `/dev/spidevN.M` devices are read/write for all members of the `wheel` group, not just `root`. Originally installed by the `pitop` USE flag on `rpi-64bit-meta`, it has since been superseded by `rpi-spi`, above.

* **sys-firmware/bcm4340a1-firmware** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides firmware (`/etc/firmware/BCM43430A1.hcd`) for the RPi's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux. Required by `net-wireless/rpi3-bluetooth` package (see above).

* **sys-firmware/brcm43430-firmware** [upstream](https://github.com/RPi-Distro/firmware-nonfree)
  * Provides a configuration file (`brcmfmac43430-sdio.txt`) that is required for the RPi3/4's integrated WiFi (the main firmware is provided already, by [`sys-kernel/linux-firmware`](http://packages.gentoo.org/package/sys-kernel/linux-firmware)). Now also provides the equivalent file `brcmfmac43455-sdio.txt`, for use with the RPi3 B+ / RPi 4 B's [dual-band WiFi](https://www.raspberrypi.com.tw/tag/bcm2837/) WiFi chip set (Cypress CYW43455), plus the matching `brcmfmac43430-sdio.clm_blob`, and, when the `43455-fix` USE flag is set, also provides a more modern copy of the uploadable file `/lib/firmware/brcm/brcmfmac43455-sdio.bin` (in preference to the older version shipped with `sys-kernel/linux-firmware`; see below).

* **x11-misc/rpi3-safecompositor**
  * Provides an eponymous OpenRC service to off display compositing, on the RPi3 only, if a high pixel clock is detected (> 1.2175MHz, currently). This is because certain applications, for example LibreOffice v6 Draw and Impress, can cause the whole system to lock-up when used with compositing on under such conditions. As of v1.4.0 of the image / v1.0.1 of the ebuild, also turns of compositing when 'true' kms mode (`vc4-kms-v3d`) is in use.

* **x11-misc/twofing** [upstream](http://plippo.de/p/twofing)
  * Provides the `twofing` daemon, which converts touchscreen gestures into mouse and keyboard events. Included primarily for use with the offical 7" RPi (1,2,3) touchscreen (not sure if this is yet compatible with the RPi4?).

* **xfce-extra/xfce4-battery-plugin**<a id="ptbattery"></a> [upstream](https://github.com/rricharz/pi-top-battery-status)
  * A modified version of the standard `xfce4-battery-plugin` gas gauge. It is patched with code from rricharz to query the status of the Pi-Top's battery over I2C; this code is activated by building `rpi-64bit-meta`  with the `pitop` USE flag (NB - _only_ for use on Pi-Top systems).

* **xfce-extra/xfce4-cpugraph-plugin** [upstream](https://goodies.xfce.org/projects/panel-plugins/xfce4-cpugraph-plugin)
  * Provides a version of this plugin that periodically completely redraws, as the original is subject to occasional display corruption.

* **xfce-extra/xfce4-fixups-rpi3**
  * Effects some useful new-user fixups for Xfce4 on the RPi3 and RPi4 (forcing compositing to sync to the vertical blank etc.). Installs an `/etc/xdg/autostart/xfce4-fixups-rpi3.desktop` entry.

* **xfce-extra/xfce4-keycuts-pitop**<a id="ptkeycuts"></a>
  * Installs some simple keyboard shortcuts for the Pi-Top (an RPi3-based DIY laptop). Only installed on the image when the `pitop` USE flag is set on `rpi-64bit-meta`.

* **xfce-extra/xfce4-noblank**
  * Provides an `/etc/xdg/autostart` script to prevent the `xscreensaver` blanking the screen, even when it is notionally 'off'.

## Other directories of interest

The following, non-ebuild directories may also be of interest:

* **metadata/news**
  * This simply contains some [GLEP 42](https://www.gentoo.org/glep/glep-0042.html)-compliant news items, specific to users of this overlay (and/or the [bootable image](https://github.com/GenPi64/gentoo-on-rpi-64bit)).

* **profiles/...**
  * This specifies the custom *profile* used by the bootable image, which contains a number of custom USE-flag assignments, package masks, keyword overrides and so forth. For more details, please see the notes [here](https://github.com/GenPi64/gentoo-on-rpi-64bit#profile).


