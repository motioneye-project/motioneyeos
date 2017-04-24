*********************
* MIPS Creator CI40 *
*********************

This document details how to build and run a Buildroot system on the
MIPS Creator CI40 platform. For more details about the CI40, see
https://creatordev.io/ci40-iot-hub.html.

How to build
------------

$ make ci40_defconfig
$ make

Prepare USB/MMC for boot
------------------------

On successful build, "sdcard.img" file will be created in 'output/images'
folder.

Use following command to write image to bootable device

$ sudo dd if=./output/images/sdcard.img of=/dev/<your-microsd-or-usb-device>

Booting from USB/MMC
--------------------

The boot loader is already present in NOR flash. To boot your newly generated
Linux and root filesystem, you need to interrupt U-Boot autoboot. Current
U-Boot is configured with 2 seconds of boot-delay, after expiry of this
boot-delay timeout U-Boot starts booting the default image. To interrupt
autoboot, press any key before the boot-delay time expires, U-Boot will
stop the autoboot process and give a U-Boot prompt. You can now boot to
your preferred boot method as describe below:

From USB
  pistachio # run usbboot

From SD-Card
  pistachio # run mmcboot

Persistent boot command
-----------------------

To boot automatically to your preferred boot method, use following command to
make it persistent, for example to automatically boot to usb:

  pistachio # setenv bootcmd run usbboot
  pistachio # saveenv

Flash new bootloader
--------------------

The bootloader image will be available in the 'output/images' folder. To flash
the new bootloader, copy it to the device and use the following command on the
device:

# flashcp -v u-boot-pistachio_marduk-<version>.img /dev/mtd0

Online docs
-----------

Mostly for OpenWRT but it is applicable to Buildroot
https://docs.creatordev.io/ci40/guides/openwrt-platform/#overview

