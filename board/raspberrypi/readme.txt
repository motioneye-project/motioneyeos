Raspberry Pi

Intro
=====

These instructions apply to all models of the Raspberry Pi:
  - the original models A and B,
  - the "enhanced" models A+ and B+,
  - the model B2 (aka Raspberry Pi 2)
  - the model B3 (aka Raspberry Pi 3).

How to build it
===============

Configure Buildroot
-------------------

There are two RaspberryPi defconfig files in Buildroot, one for each
major variant, which you should base your work on:

For models A, B, A+ or B+:

  $ make raspberrypi_defconfig

For model 2 B:

  $ make raspberrypi2_defconfig

For model 3 B:

  $ make raspberrypi3_defconfig

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
    +-- boot.vfat
    +-- kernel-marked/zImage        [2]
    +-- rootfs.ext4
    +-- rpi-firmware/
    |   +-- bootcode.bin
    |   +-- cmdline.txt
    |   +-- config.txt
    |   +-- fixup.dat
    |   `-- start.elf
    +-- sdcard.img
    `-- zImage

[1] Not all of them will be present, depending on the RaspberryPi
    model you are using.

[2] This is the mkknlimg DT-marked kernel.

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
