# genpi64-overlay

Gentoo overlay (ebuild repository) for the Raspberry Pi 3 Model B and B+, and Raspberry Pi 4 Model B. Used by my bootable [`gentoo-on-rpi-64bit`](https://github.com/sakaki-/gentoo-on-rpi-64bit) image.

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/raspberrypi/pi4/Raspberry_Pi_3_B_and_B_plus_and_4_B.jpg" alt="RPi 3 B/B+ and 4B" width="200px" align="right"/>

> NB: this repository has been renamed, from `rpi3-overlay` to `genpi64-overlay`, to reflect its applicability to the new Pi4.

> 30 Oct 2020: sadly, due legal obligations arising from a recent change in my 'real world' job, I must announce I am **standing down as maintainer of this project with immediate effect**. For the meantime, I will leave the repo up (for historical interest, and since the ebuilds etc. may be of use for others looking to take forward Gentoo on 64-bit RPi systems); however, there will be no further updates to the underlying binhost etc., nor will I be accepting / actioning further pull requests or bug reports from this point. Email requests for support will also have to be politely declined, so, **please treat this as an effective EOL notice**.<br><br>For further details, please see my post [here](https://www.raspberrypi.org/forums/viewtopic.php?p=1750206#p1750206).<br><br>Gentoo *itself* on the aarch64 / 64-bit RPi platform remains very much a going concern of course; please see e.g. [this forum](https://forums.gentoo.org/viewforum-f-62.html) for more details.<br><br>Many thanks for your interest in this project!<br><br>With sincere apologies, sakaki ><

## <a id="list_of_ebuilds"></a>List of ebuilds

The overlay provides the following ebuilds:


### Metapackage ebuilds
* **dev-embedded/rpi-64bit-meta**

  * This is the main `gentoo-on-rpi-64bit` metapackage - its version matches that of the image release. It replaces the prior `gentoo-on-rpi3-64bit` metapackage. The features it pulls in (via other ebuilds) can be customized via the following USE flags (edit via `/etc/portage/package.use/rpi-64bit-meta`):<a name="meta_use_flags"></a>
   
     | USE flag | Default? | Effect |
     | -------- | --------:| ------:|
     | `boot-fw` | Yes | Pull in the /boot firmware, configs and bootloader. |
     | `kernel-bin` | Yes | Pull in the `bcm{2711,rpi3}-kernel<-bis>-bin` binary kernel package. |
     | `porthash` | No | Pull in repo signature checker, for isshoni.org `rsync`. |
     |  `weekly-genup` | Yes | Pull in `cron.weekly` script, to run `genup` automatically. |
     | `innercore` | Yes | Pull in essential system packages for image (RPi initscripts etc.) |
     |  `core` | Yes | Pull in main packages for image (`clang` etc.). Requires `innercore`. |
     |  `xfce` | Yes | Pull in packages for baseline Xfce4 system. Requires `core`. |
     |  `pitop` | No | Pull in Pi-Top packages (NB most users **won't** want this). Requires `xfce`. |
     |  `apps` | No | Pull in baseline desktop apps (`libreoffice` etc). Requires `xfce`. |


### Ebuilds related to the [`gentoo-on-rpi-64bit`](https://github.com/sakaki-/gentoo-on-rpi-64bit) image

> Note that for historical reasons, many of these ebuilds may contain `rpi3-` in the name, but yet still be applicable on the RPi4.
* **acct-group/gpio**
  * [Similar to a `virtual`](https://wiki.gentoo.org/wiki/Categories_acct-group_and_acct-user), this is an administrative package used to define the `gpio` group (by default, gid 370).

* **acct-group/i2c**
  * As above, but for the spi group (by default, gid 371).

* **acct-group/spi**
  * As above, but for the spi group (by default, gid 372).

* **app-accessibility/onboard** [upstream](https://launchpad.net/onboard)
  * Provides a flexible onscreen keyboard. Included primarily for use with the official 7" RPi touchscreen. Adapted with thanks from original ebuild, [here](https://bitbucket.org/wjn/wjn-overlay).

* **app-office/orage** [upstream](https://git.xfce.org/apps/orage/)
  * Provides `orage-4.12.1-r1.ebuild`, patched for [bug 657542](https://bugs.gentoo.org/657542). Once this revbumps in the main Gentoo tree, `orage` should revert to using that version instead.

* **app-portage/rpi3-check-porthash**
  * Provides a [`porthash`](https://github.com/sakaki-/porthash) signed hash check for the [isshoni.org](https://isshoni.org) rsync gentoo ebuild repository, implemented as a `repo.postsync.d` hook. NB not used as of v1.3.0 of the image, as Gentoo's official `gemato` signature check is used instead; please see the release notes [here](https://github.com/sakaki-/gentoo-on-rpi-64bit/releases/tag/v1.3.0).

* **app-portage/weekly-genup**
  * Installs a simple cron.weekly script, to automate `genup`, and another, to run 'fixups' (small scripts to correct issues that may e.g. prevent correct `genup` operation, effect upstream file hierarchy migrations etc.).

* **dev-embedded/pitop-speaker**<a id="ptspeaker"></a> [upstream](https://github.com/pi-top/pi-topSPEAKER)
  * Provides the `ptspeaker` Python 3 package and accompanying OpenRC service, to initialize pitopSPEAKER add-on-boards. The init has been adapted from the original Debian package and does _not_ use `pt-peripherals-daemon`. Only installed on the image when the `pitop` USE flag is set on `rpi-64bit-meta`.

* **dev-embedded/pitop-utils**<a id="ptbrightness"></a> [upstream](https://github.com/rricharz/pi-top-install)
  * Provides the `pt-poweroff` and `pt-brightness` `sbin` utilities for the Pi-Top. Only installed on the image when the `pitop` USE flag is set on `rpi-64bit-meta`.

* **dev-embedded/rpi4-eeprom-images** [upstream](http://archive.raspberrypi.org/debian/pool/main/r/rpi-eeprom/)
  * Provides a set of EEPROM images for use by `rpi4-eeprom-updater` (see below). A weekly build-server process automatically creates new ebuilds for this package, whenever upstream releases a new EEPROM deb. For further details, please see [this post](https://www.raspberrypi.org/forums/viewtopic.php?p=1557653#p1557653).

* **dev-embedded/rpi4-eeprom-updater** [upstream](http://archive.raspberrypi.org/debian/pool/main/r/rpi-eeprom/)
  * Unlike its predecessor, the RPi4B contains a bootloader EEPROM (which replaces bootcode.bin) and also has another EEPROM region holding its VL805 USB chip's firmware. This package provides a boot-time service which checks the current versions and, if out-of-date, safely reflashes them. A weekly build-server process automatically creates new ebuilds for this package, whenever upstream releases a new deb. For further details, please see [this post](https://www.raspberrypi.org/forums/viewtopic.php?p=1557653#p1557653).

* **dev-embedded/wiringpi** [upstream](http://wiringpi.com/)
  * Provides Gordon Henderson's `WiringPi`, a PIN based GPIO access library (with accompanying `gpio` utility). Now [deprecated](http://wiringpi.com/wiringpi-deprecated/), and will not work correctly on the RPi4 in any event; use e.g. the bundled `dev-libs/pigpio` library instead (see below).

* **dev-lang/pony** [upstream](http://www.ponylang.org/)
  * Provides a few ebuilds for the `pony` language. Not installed on the image. Please see [this post, *ff.*](https://www.raspberrypi.org/forums/viewtopic.php?p=1414960#p1414960) for more background.

* **dev-lang/python** [upstream](https:/www.python.org)
  * Provides builds of the `python` language interpreter (for slots 3.6 and 3.7) that have profile guided optimisation (`pgo`) turned on, as this can yield a significant performance improvement (see e.g. [these notes](https://www.raspberrypi.org/forums/viewtopic.php?p=1528347#p1528347)).


* **dev-libs/pigpio** [upstream](http://abyz.me.uk/rpi/pigpio/index.html)
  * Provides a library, daemon (`pigpiod`), `python` bindings and CLI client (`pigs`), allowing control of the GPIOs on the RPi 3 and 4. A useful replacement for `wiringpi`, the version included here includes the necessary patches to work on an `arm64` system, and sets up the server to run, by default, on IPv4 `127.0.0.1`, port `8888` only.

* **dev-php/pthreads** [upstream](https://github.com/krakjoe/phthreads/)
  * Provides `pthreads-3.2.0`, a threading extension for `php`. Not required on the image, but used by some other packages, such as `minecraft` (see [this thread](https://www.raspberrypi.org/forums/viewtopic.php?p=1418762#p1418762) for further details).

* **mail-client/thunderbird** [upstream](https://www.mozilla.org/thunderbird)
  * Provides a number of ebuilds for this popular email client, in which attempts to use the `--disable-elf-hack` configuration option under the `clang` compiler are suppressed on `arm64` (as this breaks the build otherwise).

* **media-libs/gst-plugins-base** [upstream](https://gstreamer.freedesktop.org)
  * Provides a modified ebuild (`gst-plugins-base-1.14.5-r1`) patched to build correctly under `arm64` (prevents detection of the RPi platform, as not all interfaces are yet available within a 64-bit userland). Will be replaced by a main-tree variant on the image once one becomes available.

* **media-libs/libsdl2** [upstream](http://www.libsdl.org)
  * Provides a modified ebuild (`libsdl-2.0.10-r1`) patched to build correctly under `arm64`. Will be replaced by a main-tree variant on the image once one becomes available.

* **media-libs/mesa** [upstream](https://mesa.freedesktop.org)
  * Provides a number of lightly-patched ebuilds for this OpenGL-like graphic library, which ensure that the `v3d` drivers are also built (for the RPi4) whenever `vc4` is present in [VIDEO_CARDS](https://wiki.gentoo.org/wiki//etc/portage/make.conf#VIDEO_CARDS).

* **media-libs/raspberrypi-userland** [upstream](https://github.com/raspberrypi/userland)
  * Provides (restricted) 64-bit builds (`-DARM64=ON`) of `raspberrypi-userland`, for`vcgencmd` etc. Now also (>=1.20191025-r1) includes 6by9's provisional patchset for 64-bit userspace MMAL (so, e.g. `raspivid` and `raspistill` can be used). The ebuild needs tidying, so please use with care ><

* **media-sound/pulseaudio** [upstream](https://www.freedesktop.org/wiki/Software/PulseAudio/)
  * Provides a number of ebuilds for `pulseaudio` supporting the extra `rpi-deglitch` USE flag; this sets `tsched=0` by default, as a [workaround](https://forum.manjaro.org/t/manjaro-arm-19-08-released/99031/72) for choppy audio under certain 64-bit kernels.

* **media-video/ffmpeg** [upstream](https://ffmpeg.org/)
  * Provides a version of `ffmpeg` that has been patched to allow leverage of the RPi3/4's hardware video codecs, via V4L2 M2M, and also (>=4.2.1-r3) can use MMAL from a 64-bit userspace.

* **media-video/pi-ffcam**
  * Provides  trivial V4L2 live view app for the RPi3/4's (optional) camera module.

* **media-video/pi-ffplay**
  * Provides a trivial video player app (based on `ffplay`) that uses the RPi3/4's V4L2 M2M hardware video codecs where possible.

* **net-libs/nghttp2** [upstream](https://nghttp2.org/)
  * Provides  version of `nghttp2` that can work under `bindist`, by using the EC-patched `dev-libs/openssl` libraries (see above). Still in use on the image (as the main tree version unnecessarily forces `-bindist`).

* **net-libs/nodejs** [upstream](https://nodejs.org/)
  * Provides  version of `nodejs` that can work under `bindist`, by using the EC-patched `dev-libs/openssl` libraries (see above). Still in use on the image (for the same reason as `net-libs/nghttp2`).

* **net-misc/m-minerd** [upstream](https://github.com/magi-project/m-cpuminer-v2)
  * Provides `m-minerd-2.4.ebuild`, a CPU pool miner for M7M/Magi, adapted to build correctly under `arm64`. Not currently included on the image. Please see [this issue thread](https://github.com/sakaki-/gentoo-on-rpi-64bit/issues/38) for further details.

* **net-misc/rpi3-ethfix**
  * Effects some simple Ethernet workarounds (using `ethtool`) for the RPi3B+. It has no effect on the RPi3B or RPi4B.

* **net-misc/xorgxrdp** [upstream](http://www.xrdp.org/)
  * Provides Xorg drivers for `xrdp` (see below). Supplied on the image to allow RDP connectivity to Windows clients; see e.g. [these notes](https://github.com/sakaki-/gentoo-on-rpi-64bit/wiki/Access-your-RPi%27s-Desktop-Remotely-from-a-Windows-Box-via-RDP).

* **net-misc/xrdp** [upstream](http://www.xrdp.org/)
  * Provides `xrdp-0.9.8.ebuild` for this open source Remote Desktop Protocol server. Supplied on the image with `xorgxrdp` above.

* **net-p2p/cpuminer-multi** [upstream](https://github.com/tpruvot/cpuminer-multi)
  * Provides `cpuminer-multi-1.3.3.ebuild`, a multi-algorithm CPU cryptocurrency miner adapted to build correctly under `arm64`. Not currently included on the image. Please see [this post *ff.*](https://www.raspberrypi.org/forums/viewtopic.php?p=1317164#p1317164) for further details.

* **net-wireless/blueman** [upstream](https://github.com/blueman-project/blueman)
  * Provides `blueman-2.0.4-r1.ebuild`; this has been removed from the main Gentoo tree, but is in use on the image (until the current version proves stable, at which point it will be unmasked, and `blueman` will revert to using the main-tree ebuild).

* **net-wireless/rpi3-bluetooth** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides a startup service and `udev` rule for the RPi3/4's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux.

* **net-wireless/rpi3-wifi-regdom** Provides a simple service to set the WiFi regulatory domain; the value set may be modified by editing the file `/etc/conf.d/rpi3-wifi-regdom`.

* **sys-apps/openrc** [upstream](https://github.com/openrc/openrc/)
  * Provided lightly modified ebuilds for this, Gentoo's native init system, supporting the additional `swclock-fix` USE flag. This flag (set on the image) patches the startup code to attempt to overcome annoying clock-skew messages that can occur at boot (the `swclock` service is used on systems like the RPi, which has no RTC). Please see [these notes](https://gitlab.alpinelinux.org/alpine/aports/issues/8093) for some further background.

* **sys-apps/pitop-poweroff**<a id="ptpoweroff"></a>
  * Provides a simple OpenRC shutdown service, to ensure that the Pi-Top's onboard hub controller is properly powered down. Only installed when the `pitop` USE flag is set on `rpi-64bit-meta`.


* **sys-apps/pyconfig_gen** [upstream](https://github.com/sakaki-/pyconfig_gen)
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

* **sys-apps/rpi3-expand-swap**
  * Expands the default swapfile (`/var/cache/swap/swap1`) to 1,024MiB on first boot (after the root filesystem has been expanded), subject to sufficient space.

* **sys-apps/rpi3-i2cdev**
  * Provides an OpenRC service and `udev` rule for I2C access on the RPi3/4. Ensures that the `i2c-dev` module is `modprobe`d, and that the `/dev/i2c-[0-9]` devices are read/write for all members of the `wheel` group, not just `root`. Originally installed by the `pitop` USE flag on `rpi-64bit-meta`, it has since been superseded by `rpi-i2c`, above.

* **sys-apps/rpi3-init-scripts**
  * Provides a few simple init scripts for the [gentoo-on-rpi-64bit](https://github.com/sakaki-/gentoo-on-rpi-64bit) image (to autoexpand the root partition on first boot, inhibit XVideo, setup cache usage appropriate for a low-memory environment etc.).

* **sys-apps/rpi3-ondemand-cpufreq**
  * Provides the `rpi3-ondemand` OpenRC `sysinit` service, to switch the RPi3 and RPi4 from its (`bcmrpi3_defconfig` and `bcm2711_defconfig`) default `powersave` CPU frequency governor, to `ondemand`, for better performance.

* **sys-apps/rpi3-spidev**
  * Provides a `udev` rule for SPI access on the RPi3; ensures that the `/dev/spidevN.M` devices are read/write for all members of the `wheel` group, not just `root`. Originally installed by the `pitop` USE flag on `rpi-64bit-meta`, it has since been superseded by `rpi-spi`, above.


* **sys-boot/rpi3-64bit-firmware** [upstream](https://github.com/raspberrypi/firmware)
  * Provides the firmware and config files required in `/boot` to boot the RPi3/4 in 64-bit mode. Does not provide the kernel or DTBs (see `sys-kernel/bcmrpi3-kernel<-bis>-bin`, above, for that). A weekly check is made to see if a new tag has been added to the official [`raspberrypi/firmware/boot`](https://github.com/raspberrypi/firmware/tree/master/boot) upstream, and, if so, a matching ebuild is automatically created here. With the `dtbo` USE flag off (as forced [by the profile](https://github.com/sakaki-/genpi64-overlay/blob/master/profiles/targets/rpi3/package.use/rpi3-64bit-firmware), currently), does _not_ provide or populate the `/boot/overlays` directory - this then being the responsibility of the binary kernel package.

* **sys-boot/rpi3-boot-config**
  * Provides the 'starter' RPi3/4 configuration files `/boot/cmdline.txt` and `/boot/config.txt` (in both standard and Pi-Top trim).

* **sys-devel/portage-distccmon-gui**
  * Desktop file (and wrapper) to view Portage jobs with `distccmon-gui` (provided your user is a member of the `portage` group).

* **sys-firmware/bcm4340a1-firmware** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides firmware (`/etc/firmware/BCM43430A1.hcd`) for the RPi's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux. Required by `net-wireless/rpi3-bluetooth` package (see above).

* **sys-firmware/brcm43430-firmware** [upstream](https://github.com/RPi-Distro/firmware-nonfree)
  * Provides a configuration file (`brcmfmac43430-sdio.txt`) that is required for the RPi3/4's integrated WiFi (the main firmware is provided already, by [`sys-kernel/linux-firmware`](http://packages.gentoo.org/package/sys-kernel/linux-firmware)). Now also provides the equivalent file `brcmfmac43455-sdio.txt`, for use with the RPi3 B+ / RPi 4 B's [dual-band WiFi](https://www.raspberrypi.com.tw/tag/bcm2837/) WiFi chip set (Cypress CYW43455), plus the matching `brcmfmac43430-sdio.clm_blob`, and, when the `43455-fix` USE flag is set, also provides a more modern copy of the uploadable file `/lib/firmware/brcm/brcmfmac43455-sdio.bin` (in preference to the older version shipped with `sys-kernel/linux-firmware`; see below).

* **sys-kernel/bcm2711-kernel-bin**
  * Provides ebuilds to install the available binary packages for the 64-bit `bcm2711_defconfig` Linux kernels (for the Raspberry Pi 4 model B), which are updated weekly [here](https://github.com/sakaki-/bcm2711-kernel).

* **sys-kernel/bcm2711-kernel-bis-bin**

    Provides ebuilds to install the available binary packages for (slightly tweaked versions of) the 64-bit `bcm2711_defconfig` Linux kernels (for the Raspberry Pi 4 model B), which are updated weekly [here](https://github.com/sakaki-/bcm2711-kernel-bis). This version is used by default in preference to `bcm2711-kernel-bin` as of v1.5.0 of the image, as it includes some additional kernel configuration items such as KVM (but either is acceptable).

* **sys-kernel/bcmrpi3-kernel-bin**
  * Provides ebuilds to install the available binary packages for the 64-bit `bcmrpi3_defconfig` Linux kernels (for the Raspberry Pi 3 model B and B+), which are updated weekly [here](https://github.com/sakaki-/bcmrpi3-kernel).

* **sys-kernel/bcmrpi3-kernel-bis-bin**
  * Provides ebuilds to install the available binary packages for (slightly tweaked versions of) the 64-bit `bcmrpi3_defconfig` Linux kernels (for the Raspberry Pi 3 model B and B+), which are updated weekly [here](https://github.com/sakaki-/bcmrpi3-kernel-bis). This version is used in preference to `bcmrpi3-kernel-bin` as of v1.2.2 of the bootable image, since it includes some additional kernel configuration items such as KVM (but either is acceptable).

* **sys-kernel/linux-firmware** [upstream](https://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git)
  * Provides a large collection of redistributable Linux firmware files. The version in this overlay supports the `43455-fix` USE flag, which when set does _not_ install the file `/lib/firmware/brcm/brcmfmac43455-sdio.bin` (allowing a more modern version to be supplied by `sys-firmware/brcm43430-firmware`; see above).

* **virtual/pam**
  * Just provides a shadow copy of `virtual/pam-0-r1`, preparatory to this being removed from the main tree (announced but not yet effected at the time of writing) &mdash; as it is still a dep of some packages currently in use on the image.

* **virtual/rust**
  * Provides a virtual for version 1.31.1-r1 of the `rust` compiler. Retained for historical interest only - more modern (>=1.32.2) main tree versions are now used in the image.

* **www-client/chromium** [upstream](http://chromium.org/)
  * Provides a number of versions of the open-source browser `chromium`, capable of being built in a `bindist` compatible manner (by suppressing all software-based `h264` codec inclusions). Also forces the use of `clang` as the compiler.

* **www-client/firefox** [upstream](http://www.mozilla.com/firefox)
  * Provides patched ebuilds for the full-scale `firefox` browser. Retained in the overlay for historical interest only, as modern (>=68.2.0) main-tree versions of `firefox` build successfully under `arm64` (and just such a main-tree build is currently used on the image).

* **x11-base/xorg-server** [upstream](https://gitlab.freedesktop.org/xorg/xserver/xorg-server)
  * Provides `xorg-server-1.19.6-r1.ebuild` for the X11 server, adapted to build correctly under `arm64`. Retained for historical interest only - more modern (>=1.20.5) main tree versions are now used in the image.

* **x11-misc/arandr** [upstream](https://christian.amsuess.com/tools/arandr/)
  * Provides a slightly patched version of the `arandr` screen configuration GUI, which automatically applies setup files saved as `~/.screenlayout/default.sh` upon login (incidentally, this autoload can be suppressed by holding down <kbd>Ctrl</kbd> during boot).

* **x11-misc/rpi3-safecompositor**
  * Provides an eponymous OpenRC service to off display compositing, on the RPi3 only, if a high pixel clock is detected (> 1.2175MHz, currently). This is because certain applications, for example LibreOffice v6 Draw and Impress, can cause the whole system to lock-up when used with compositing on under such conditions. As of v1.4.0 of the image / v1.0.1 of the ebuild, also turns of compositing when 'true' kms mode (`vc4-kms-v3d`) is in use.

* **x11-misc/rpi3-safecursor**
  * Provides the `rpi3-safecursor` OpenRC service, which will install a rule to force software cursor blitting (rather than the hardware default) if the user has not set `disable_overscan=1` in `config.txt`. (Required because hardware cursor blitting in the open-source vc4 driver does not always take account of the overscan 'bezel' correctly on HDMI TVs, resulting in an offset cursor.) The service no-ops with any >= 4.14.y kernel however (e.g., the 4.19.y currently supplied with the image), as these have the fix [already committed](https://github.com/raspberrypi/linux/commit/81bbe80e7bebab6211c72bf0c0f81a4bc2370eab).

* **x11-misc/twofing** [upstream](http://plippo.de/p/twofing)
  * Provides the `twofing` daemon, which converts touchscreen gestures into mouse and keyboard events. Included primarily for use with the offical 7" RPi (1,2,3) touchscreen (not sure if this is yet compatible with the RPi4?).

* **x11-themes/gnome-icon-theme** [upstream](https://www.gnome.org)
  * Provides `gnome-icon-theme-3.12.0-r1.ebuild`; this has been removed from the main Gentoo tree, but is still required for some icons on the image.

* **x11-themes/gtk-engines-xfce** [upstream](https://www.xfce.org/projects/)
  * Provides a shadow copy of `gtk-engines-xfce-r{2,3}01`, preparatory to these being removed from the main tree (announced but not yet effected at the time of writing) &mdash; as still a dep of some packages currently in use on the image.

* **xfce-extra/xfc4-mixer** [upstream](http://softwarebakery.com/maato/volumeicon.html)
  * Provides `xfc4-mixer-4.99.0-r1`, a 'pseudo-package' replacing the original, treecleaned `xfce4-mixer` with the (broadly equivalent) `media-sound/volumeicon` package.

* **xfce-extra/xfce4-battery-plugin**<a id="ptbattery"></a> [upstream](https://github.com/rricharz/pi-top-battery-status)
  * A modified version of the standard `xfce4-battery-plugin` gas gauge. It is patched with code from rricharz to query the status of the Pi-Top's battery over I2C; this code is activated by building `rpi-64bit-meta`  with the `pitop` USE flag (NB - _only_ for use on Pi-Top systems).

* **xfce-extra/xfce4-cpugraph-plugin** [upstream](https://goodies.xfce.org/projects/panel-plugins/xfce4-cpugraph-plugin)
  * Provides a version of this plugin that periodically completely redraws, as the original is subject to occasional display corruption.

* **xfce-extra/xfce4-fixups-rpi3**
  * Effects some useful new-user fixups for Xfce4 on the RPi3 and RPi4 (forcing compositing to sync to the vertical blank etc.). Installs an `/etc/xdg/autostart/xfce4-fixups-rpi3.desktop` entry.

* **xfce-extra/xfce4-indicator-plugin** [upstream](https://goodies.xfce.org/projects/panel-plugins/xfce4-indicator-plugin)
  * Provides `xfce4-indicator-plugin-2.3.3-r2.ebuild`; this has been removed from the main Gentoo tree, and v2.3.4 is currently masked.

* **xfce-extra/xfce4-keycuts-pitop**<a id="ptkeycuts"></a>
  * Installs some simple keyboard shortcuts for the Pi-Top (an RPi3-based DIY laptop). Only installed on the image when the `pitop` USE flag is set on `rpi-64bit-meta`.

* **xfce-extra/xfce4-noblank**
  * Provides an `/etc/xdg/autostart` script to prevent the `xscreensaver` blanking the screen, even when it is notionally 'off'.

* **xfce-extra/xfce4-notifyd** [upstream](https://goodies.xfce.org/projects/applications/xfce4-notifyd)
  * Provides `xfce4-notifyd-0.4.0.ebuild`; this has been removed from the main Gentoo tree, but is still used on the image. Upgrades masked because of message truncation, which causes problems with PIN notification during Bluetooth device setup. To be fixed / resolved.


## Other directories of interest

The following, non-ebuild directories may also be of interest:

* **metadata/news**
  * This simply contains some [GLEP 42](https://www.gentoo.org/glep/glep-0042.html)-compliant news items, specific to users of this overlay (and/or the [bootable image](https://github.com/sakaki-/gentoo-on-rpi-64bit)).

* **profiles/...**
  * This specifies the custom *profile* used by the bootable image, which contains a number of custom USE-flag assignments, package masks, keyword overrides and so forth. For more details, please see the notes [here](https://github.com/sakaki-/gentoo-on-rpi-64bit#profile).


