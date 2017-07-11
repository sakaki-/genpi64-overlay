# rpi3-overlay
Gentoo overlay for the Raspberry Pi 3

## List of ebuilds

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/raspberrypi/pi3/Raspberry_Pi_3_B.jpg" alt="Raspberry Pi 3 B" width="250px" align="right"/>

* **sys-firmware/brcm43430-firmware** [upstream](https://github.com/RPi-Distro/firmware-nonfree)
  * Just provides a configuration file (`brcmfmac43430-sdio.txt`) that is required for the RPi3's integrated WiFi (the main firmware is provided already, by [`sys-kernel/linux-firmware`](http://packages.gentoo.org/package/sys-kernel/linux-firmware)).
* **sys-firmware/bcm4340a1-firmware** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides firmware (`/etc/firmware/BCM43430A1.hcd`) for the RPi3's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux. Required by `net-wireless/rpi3-bluetooth` package (see below).
* **net-wireless/rpi3-bluetooth** [upstream](https://aur.archlinux.org/packages/pi-bluetooth/)
  * Provides a startup service and `udev` rule for the RPi3's integrated Bluetooth transceiver. Adapted from the [`pi-bluetooth`](https://aur.archlinux.org/packages/pi-bluetooth/) package from ArchLinux.
* **sys-devel/portage-distccmon-gui**
  * Desktop file (and wrapper) to view Portage jobs with `distccmon-gui` (provided your user is a member of the `portage` group).
* **sys-kernel/bcmrpi3-kernel-bin**
  * Provides ebuilds to install the available binary packages for the 64-bit `bcmrpi3_defconfig` Linux kernels (for the Raspberry Pi 3 model B), which are updated weekly [here](https://github.com/sakaki-/bcmrpi3-kernel).
* **www-client/firefox** [upstream](https://wiki.gentoo.org/wiki/Project:Mozilla)
  * Provides `firefox-50.1.0-r1.ebuild`; this has been removed from the Gentoo tree, but it works well under `~amd64` (with the `skia` USE flag unset). (No longer necessary, as modern versions now build, but retained for historical interest.)
* **media-libs/raspberrypi-userland**
  * Provides `raspberrypi-userland-9999.ebuild`, a (restricted) 64-bit build (`-DARM64=ON`).
* **sys-apps/rpi3-init-scripts**
  * Provides a few simple init scripts for the [gentoo-on-rpi3-64bit](https://github.com/sakaki-/gentoo-on-rpi3-64bit) image (to autoexpand the root partition on first boot, etc.).
* **sys-apps/rpi3-ondemand-cpufreq**
  * Provides the `/etc/local.d/ondemand_freq_scaling.start` boot script, to switch the RPi3 from its (`bcmrpi3_defconfig`) default `powersave` CPU frequency governor, to `ondemand`, for better performance.
* **app-portage/rpi3-check-porthash**
  * Provides a [`porthash`](https://github.com/sakaki-/porthash) signed hash check for the [isshoni.org](https://isshoni.org) rsync gentoo ebuild repository, implemented as a `repo.postsync.d` hook.
* **sys-boot/rpi3-64bit-firmware** [upstream](https://github.com/raspberrypi/firmware)
  * Provides the firmware and config files required in `/boot` to boot the RPi3 in 64-bit mode. Does not provide the kernel or DTBs (see `sys-kernel/bcmrpi3-kernel-bin`, above, for that). A weekly check is made to see if a new tag has been added to the official [`raspberrypi/firmware/boot`](https://github.com/raspberrypi/firmware/tree/master/boot) upstream, and, if so, a matching ebuild is automatically created here.

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
