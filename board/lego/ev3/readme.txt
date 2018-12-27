Lego Mindstorms EV3

Intro
=====

This is the buildroot basic board support for the Lego Mindstorms EV3
programmable brick.

The Lego Mindstorms EV3 brick comprises a Texas Instruments AM1808 SoC, with
an ARM 926EJ-S main processor running at 300 MHz.
See:
- https://en.wikipedia.org/wiki/Lego_Mindstorms_EV3
- http://www.lego.com/en-us/mindstorms/products/ev3/31313-mindstorms-ev3/
- http://www.ti.com/product/am1808

How it works
============

Boot process :
--------------

The EV3 boots from an EEPROM. This loads whatever is on the built-in 16MB flash
(usually U-Boot) and runs it. The U-Boot from the official LEGO firmware and
mainline U-Boot will attempt to boot a Linux kernel from the external µSD card.
It will try to load a uImage (and optional boot.scr) from the first µSD card
partition, which must be formatted with a FAT filesystem. If no µSD is found or
it does not contain a uImage file, then the EV3 will boot the uImage from the
built-in 16MB flash.

How to build it
===============

Configure Buildroot
-------------------

The lego_ev3_defconfig configuration provides basic support to boot on the Lego
Mindstorms EV3 programmable brick:

  $ make lego_ev3_defconfig

Build everything
----------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

  $ make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    ├── boot.vfat
    ├── flash.bin
    ├── rootfs.ext2
    ├── rootfs.ext3 -> rootfs.ext2
    ├── rootfs.squashfs
    ├── sdcard.img
    ├── u-boot.bin
    ├── uImage -> uImage.da850-lego-ev3
    └── uImage.da850-lego-ev3

Installation
============

You can use either flash.bin or the sdcard.img. To load flash.bin, use the
official Lego Mindstorms EV3 programming software firmware update tool to load
the image. To use sdcard.img, use a disk writing tool such as Etcher or dd to
write the image to the µSD card.

NOTE: The sdcard.img created by lego_ev3_defconfig won't boot if the official
LEGO firmware is installed on the EV3 (it has an old version of U-Boot that
doesn't know about device tree). You must either set the kernel configuration
option to append the device tree to the kernel or you can create a boot.scr
that chainloads a newer U-Boot or you can install a newer U-Boot in the flash
memory (just flashing u-boot.bin is enough).

Finish
======

To have a serial console, you will need a proper USB to Lego serial port
adapter plugged into the EV3 sensors port 1.
See:
- http://botbench.com/blog/2013/08/15/ev3-creating-console-cable/
- http://botbench.com/blog/2013/08/05/mindsensors-ev3-usb-console-adapter/

The serial port config to use is 115200/8-N-1.

Bluetooth
=========

To enable Bluetooth:

    # modprobe hci_uart
    # /usr/libexec/bluetooth/bluetoothd &
    # bluetoothctl
    [bluetooth]# power on
