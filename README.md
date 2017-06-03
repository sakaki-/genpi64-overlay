# rpi3-overlay
Gentoo overlay for the Raspberry Pi 3

## List of ebuilds

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/raspberrypi/pi3/Raspberry_Pi_3_B.jpg" alt="Raspberry Pi 3 B" width="250px" align="right"/>

* **www-client/firefox** [upstream](https://wiki.gentoo.org/wiki/Project:Mozilla)
  * Provides `firefox-50.1.0-r1.ebuild`; this has been removed from the Gentoo tree, but it works well under `~amd64` (with the `skia` USE flag unset).
* **media-libs/raspberrypi-userland**
  * Provides `raspberrypi-userland-9999.ebuild`, a (restricted) 64-bit build (`-DARM64=ON`).
* **sys-kernel/bcmrpi3-kernel-bin-\<version\>**
  * Provides ebuilds to install the available binary packages for the 64-bit `bcmrpi3_defconfig` Linux kernels (for the Raspberry Pi 3 model B), which are updated weekly [here](https://github.com/sakaki-/bcmrpi3-kernel).

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

    # emerge --ask --verbose =www-client/firefox-50.1.0-r1

## Maintainers

* [sakaki](mailto:sakaki@deciban.com)
