**********************
SolidRun Clearfog Base
**********************

This file documents Buildroot's support for the Clearfog Base by Solid Run.

Vendor's documentation:
https://wiki.solid-run.com/doku.php?id=products:a38x:documents

Warning for eMMC variant of the MicroSoM
========================================

If you bought a MicroSoM version that includes an on-board eMMC flash, the
built-in microSD card slot *WILL NOT WORK*. The Internet says that you have to
upload the first bootloader via UART. This manual does not cover these steps;
only MicroSoMs without the eMMC are supported.

Build
=====

Start with the default Buildroot's configuration for Clearfog:

  make solidrun_clearfog_defconfig

Build all components:

  make

The results of the build are available in ./output/images.

Create a bootable SD card
=========================

To determine the device associated to the SD card have a look in the
/proc/partitions file:

  cat /proc/partitions

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a microSD card. Launch the following
command as root:

  dd if=output/images/sdcard.img of=/dev/<your-microsd-device> conv=fdatasync

*** WARNING! The dd command will destroy all the card content. Use with care! ***

For details about the medium image layout, see the definition in
board/solidrun/clearfog/genimage.cfg.

Boot the Clearfog board
=======================

Here's how to boot the board:

- Set up the DIP switches for microSD boot. The correct values are:
  1: off, 2: off, 3: ON, 4: ON, 5: ON. In this scheme, switch #1" is closer to
  the ethernet ports and #5 is closer to the microSD card, "ON" means towards
  the SOM, and "off" means towards the SFP cage.
- Connect to the board's console over the microUSB port.
- Insert the SD card into the slot on the board (pins up).
- Power up the board.
