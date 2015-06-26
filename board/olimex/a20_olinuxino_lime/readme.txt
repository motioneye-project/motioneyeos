A20-OLinuXino-LIME

Intro
=====

This is a open hardware board,
see https://www.olimex.com/Products/OLinuXino/open-source-hardware

How to build it
===============

    $ make olimex_a20_olinuxino_lime_defconfig

Compile everything and build the rootfs image:

    $ make

Result of the build
-------------------

After building, you should get a tree like this:

    output/images/
    +-- rootfs.ext2
    +-- rootfs.ext4 -> rootfs.ext2
    +-- sun7i-a20-olinuxino-lime.dtb
    +-- u-boot.bin
    +-- u-boot-sunxi-with-spl.bin
    `-- zImage


How to write the SD card
========================


Prepare the SD card
-------------------

Erase existing stuff, and create an unique Linux partition with `fdisk`.

    # fdisk /dev/sdX
    Command (m for help): o
    Building a new DOS disklabel with disk identifier 0xf9e1616a.
    Changes will remain in memory only, until you decide to write them.
    After that, of course, the previous content won't be recoverable.

    Command (m for help): n
    Partition type:
        p   primary (0 primary, 0 extended, 4 free)
        e   extended
    Select (default p): p
    Partition number (1-4, default 1): 1
    First sector (2048-7626751, default 2048): 2048
    Last sector, +sectors or +size{K,M,G} (2048-7626751, default 7626751): 
    Using default value 7626751

    Command (m for help): p

    Disk /dev/sdX: 3904 MB, 3904897024 bytes
    4 heads, 16 sectors/track, 119168 cylinders, total 7626752 sectors
    Units = sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disk identifier: 0xf9e1616a

            Device Boot      Start         End      Blocks   Id  System
    /dev/sdX1                 2048     7626751     3812352   83  Linux

    Command (m for help): w
    The partition table has been altered!

    Calling ioctl() to re-read partition table.
    Syncing disks.

Copy images on the SD card
--------------------------

    # dd if=output/images/rootfs.ext2 of=/dev/sdX1
    # dd if=output/images/u-boot-sunxi-with-spl.bin of=/dev/sdX bs=1024 seek=8


Finish
======

Eject the SD card, insert it in the A20-OLinuXino-LIME board, and power it up.

