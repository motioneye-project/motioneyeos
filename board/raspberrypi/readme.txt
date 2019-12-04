Raspberry Pi

Intro
=====

These instructions apply to all models of the Raspberry Pi:
  - the original models A and B,
  - the "enhanced" models A+ and B+,
  - the model B2 (aka Raspberry Pi 2)
  - the model B3 (aka Raspberry Pi 3).
  - the model B4 (aka Raspberry Pi 4).

How to build it
===============

Configure Buildroot
-------------------

There are two RaspberryPi defconfig files in Buildroot, one for each
major variant, which you should base your work on:

For models A, B, A+ or B+:

  $ make raspberrypi_defconfig

For model Zero (model A+ in smaller form factor):

  $ make raspberrypi0_defconfig

For model 2 B:

  $ make raspberrypi2_defconfig

For model 3 B and B+:

  $ make raspberrypi3_defconfig

For model 4 B:

  $ make raspberrypi4_defconfig

Build the rootfs
----------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

You may now build your rootfs with:

  $ make

(This may take a while, consider getting yourself a coffee ;-) )

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    +-- bcm2708-rpi-b.dtb           [1]
    +-- bcm2708-rpi-b-plus.dtb      [1]
    +-- bcm2709-rpi-2-b.dtb         [1]
    +-- bcm2710-rpi-3-b.dtb         [1]
    +-- bcm2710-rpi-3-b-plus.dtb    [1]
    +-- bcm2711-rpi-4-b.dtb         [1]
    +-- boot.vfat
    +-- rootfs.ext4
    +-- rpi-firmware/
    |   +-- bootcode.bin
    |   +-- cmdline.txt
    |   +-- config.txt
    |   +-- fixup.dat
    |   +-- start.elf
    |   `-- overlays/               [2]
    +-- sdcard.img
    `-- zImage

[1] Not all of them will be present, depending on the RaspberryPi
    model you are using.

[2] Only for the Raspberry Pi 3/4 Models (overlay miniuart-bt is needed
    to enable the RPi3 serial console otherwise occupied by the bluetooth
    chip). Alternative would be to disable the serial console in cmdline.txt
    and /etc/inittab.

How to write the SD card
========================

Once the build process is finished you will have an image called "sdcard.img"
in the output/images/ directory.

Copy the bootable "sdcard.img" onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX

Insert the SDcard into your Raspberry Pi, and power it up. Your new system
should come up now and start two consoles: one on the serial port on
the P1 header, one on the HDMI output where you can login using a USB
keyboard.
