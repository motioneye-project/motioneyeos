A20-OLinuXino-LIME and A20-OLinuXino-MICRO

Intro
=====

These are open hardware boards, all based on the Allwinner A20 SoC.

for more details about the boards see the following pages:
 - https://www.olimex.com/Products/OLinuXino/open-source-hardware
 - https://www.olimex.com/Products/OLinuXino/A20/A20-OLinuXino-MICRO/
 - https://www.olimex.com/Products/OLinuXino/A20/A20-OLinuXino-LIME/
 - https://www.olimex.com/Products/OLinuXino/A20/A20-OLinuXino-LIME2/

The following defconfigs are available:
 - olimex_a20_olinuxino_micro_defconfig
   for the A20-OLinuXino-MICRO board using mainline kernel
 - olimex_a20_olinuxino_lime_defconfig
   for the A20-OLinuXino-LIME board using mainline kernel
 - olimex_a20_olinuxino_lime2_defconfig
   for the A20-OLinuXino-LIME2 board using mainline kernel

The Mainline Kernel is already a much better choice for a headless server.
And also the mainline kernel works fine even for a basic Linux desktop
system running on top of a simple framebuffer, which may be good enough for
the users who do not need fancy 3D graphics or video playback acceleration.

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
    +-- rootfs.ext2
    +-- rootfs.ext4 -> rootfs.ext2
    +-- sdcard.img
    +-- sun7i-a20-olinuxino-lime.dtb (lime, mainline)
    +-- sun7i-a20-olinuxino-lime2.dtb (lime2, mainline)
    +-- sun7i-a20-olinuxino-micro.dtb (micro, mainline)
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

Eject the SD card, insert it in the A20-OLinuXino board, and power it up.

