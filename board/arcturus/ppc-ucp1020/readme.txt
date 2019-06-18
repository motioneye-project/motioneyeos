Arcturus uCP1020 SoM
====================

This tutorial describes how to use the predefined Buildroot
configuration for the Arcturus uCP1020 SoM platform.

Additional information about this module can be found at
<www.arcturusnetworks.com/products/ucp1020>

Building
--------

  make arcturus_ucp1020_defconfig
  make

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    +-- rootfs.jffs2
    +-- rootfs.tar
    +-- u-boot.bin
    +-- ucp1020.dtb
    +-- uImage

Flashing
--------

You'll need to program the files created by buildroot into the NOR flash.

1. Program the new U-Boot binary (optional)
    If you don't feel confident upgrading your bootloader then don't do it,
    it's unnecessary most of the time.

    B$ tftp u-boot.bin
    B$ protect off 0xeff80000 +$filesize
    B$ erase 0xeff80000 +$filesize
    B$ cp.b $loadaddr 0xeff80000 $filesize
    B$ protect on 0xeff80000 +$filesize

2. Program the kernel

    B$ tftp uImage
    B$ erase 0xec140000 +$filesize
    B$ cp.b $loadaddr 0xec140000 $filesize

3. Program the DTB

    B$ tftp ucp1020.dtb
    B$ erase 0xec100000 +$filesize
    B$ cp.b $loadaddr 0xec100000 $filesize

4. Program the jffs2 root filesystem

    B$ tftp rootfs.jffs2
    B$ erase 0xec800000 0xee8fffff
    B$ cp.b $loadaddr 0xec800000 $filesize

5. Booting your new system

    B$ setenv norboot 'setenv bootargs root=/dev/mtdblock1 rootfstype=jffs2 console=$consoledev,$baudrate;bootm 0xec140000 - 0xec100000'

    If you want to set this boot option as default:

    B$ setenv bootcmd 'run norboot'
    B$ saveenv

    ...or for a single boot:

    B$ run norboot

Good Luck !
