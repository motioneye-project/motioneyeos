A10-OLinuXino-LIME

Intro
=====

These are open hardware boards, all based on the Allwinner A10 SoC.

for more details about the boards see the following pages:
 - https://www.olimex.com/Products/OLinuXino/open-source-hardware
 - https://www.olimex.com/Products/OLinuXino/A10/A10-OLinuXino-LIME/

The following defconfigs are available:
 - olimex_a10_olinuxino_lime_defconfig
   for the A10-OLinuXino-LIME board using mainline kernel

(see http://linux-sunxi.org/Linux_Kernel for more details)

How to build it
===============

Configure Buildroot:

    $ make <board>_defconfig

Compile everything and build the rootfs image:

    $ make

Result of the build
-------------------

After building, you should get a tree like this:

    output/images/
    +-- boot.scr
    +-- rootfs.ext2
    +-- rootfs.ext4 -> rootfs.ext2
    +-- sdcard.img
    +-- sun4i-a10-olinuxino-lime.dtb (lime, mainline)
    +-- u-boot.bin
    +-- u-boot-sunxi-with-spl.bin
    `-- zImage


How to write the SD card
========================

The sdcard.img file is a complete bootable image ready to be written
on the boot medium. To install it, simply copy the image to a uSD
card:

    # dd if=output/images/sdcard.img of=/dev/sdX

Where 'sdX' is the device node of the uSD.

Eject the SD card, insert it in the A10-OLinuXino board, and power it up.

