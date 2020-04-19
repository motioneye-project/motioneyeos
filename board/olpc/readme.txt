OLPC XO Laptops
===============

This document explains how to build and run images that run on the OLPC
XO laptops.

Supported models
----------------

* OLPC XO-1
  The original NS Geode based OLPC laptop, uses the x86 architecture.

* OLPC XO-7.5
  The ARM-based laptop. Needs a recent enough firmware to provide a good
  enough flattened device tree to the kernel.

Configure and build
===================

  $ make olpc_xo1_defconfig   # Configure for XO-1

or:

  $ make olpc_xo175_defconfig # Configure for XO-1.75

Then:

  $ make menuconfig           # Customize the build configuration
  $ make                      # Build

Create the bootable media
=========================

When the build is finished, the resulting image file will be called
"sdcard.img". It can be written directly to a SD-card or and USB flash stick.

Please double check that you're using the right device (e.g. with "lsblk"
command). Doing the following will DESTROY ALL DATA that's currently on the
media.

  # cat output/images/sdcard.img >/dev/<device>

Preparing the machine
=====================

Firmware security
-----------------

Most OLPC machines were shipped with the security system that disallows
booting unsigned software. If this is the case with your machine, in order
to run the image you've built on it you'll need to get a developer key and
deactivate the security system.

The procedure is descriped in the OLPC wiki:
http://wiki.laptop.org/go/Activation_and_Developer_Keys

Firmware upgrade
----------------

It is always preferrable to use an up to date firmware. The firmware images
are available at http://wiki.laptop.org/go/Firmware. For the XO-1.75 laptop
to boot the mainline kernel a firmware Q4E00JA or newer is needed. You can
get it at http://dev.laptop.org/~quozl/q4e00ja.rom.

To update the firmware, place the .rom file on to your bootable media,
connect a charged battery pack and a wall adapter, and enter the Open
Firmware prompt by pressing ESC during the early boot (needs an unlocked
laptop -- see "Firmware security" above). Then use the "flash" command
to update the firmware:

  ok flash ext:\q4e00ja.rom   \ Flash the "q4e00ja.rom" from the SD card
  ok flash u:\q4e00ja.rom     \ Flash the "q4e00ja.rom" from USB stick

Booting the machine
===================

Once your machine is unlocked, it will automatically boot from your media
wherever it will detect it attached to the USB bus or the SD card slot.
