ARM Juno r1/r0

Intro
=====

These instructions apply to all models of the ARM Juno:
  - Juno r0 (does not support PCIe)
  - Juno r1 (supports PCIe)
  - Juno r2 (Big Cluster with A72)

Buildroot will generate the kernel image, device tree blob, bootloader binaries
and a minimal root filesystem.

How to build it
===============

Configure Buildroot
-------------------

Configuring Buildroot is pretty simple, just execute:

  $ make arm_juno_defconfig

Build the rootfs, kernel and DTB
--------------------------------

Note: you will need to have access to the network, since Buildroot will
download the packages' sources.

You may now build your rootfs with:

  $ make

(This may take a while)

Result of the build
-------------------

After building, you should obtain this tree:

    output/images/
    +-- rootfs.tar
    +-- juno.dtb (if Juno r0 is used)
    +-- juno-r1.dtb (if Juno r1 is used)
    +-- juno-r2.dtb (if Juno r2 is used)
    +-- Image
    +-- bl1.bin
    +-- bl2.bin
    +-- bl2u.bin
    +-- bl31.bin
    +-- fip.bin
    +-- scp-fw.bin
    +-- u-boot.bin

Preparing your rootfs
======================

Format your pen drive as a ext3 filesystem by executing:

   $ mkfs.ext3 /dev/<your device>

Preparing your rootfs
======================

Format your pen drive as a ext3 filesystem by executing:

   $ mkfs.ext3 /dev/<your device>

Installing your rootfs
======================

After mounting the pen drive please execute the following:

   $ sudo tar -xvf output/images/rootfs.tar -C <pen drive mount path>

When completed make sure to unmount the device:

   $ umount <pen drive mount path>

Insert the pen drive in one of the ARM Juno' USB type A connectors.

Configure *.dtb in the boot configuration for Juno r0
=====================================================

SITE1/HBI0262B/images.txt
.....
NOR3UPDATE: AUTO                 ;Image Update:NONE/AUTO/FORCE
NOR3ADDRESS: 0x00C00000          ;Image Flash Address
NOR3FILE: \SOFTWARE\juno.dtb     ;Image File Name
NOR3NAME: board.dtb              ;Specify Image name to preserve file extension
NOR3LOAD: 00000000               ;Image Load Address
NOR3ENTRY: 00000000              ;Image Entry Point
......

Configure *.dtb in the boot configuration for Juno r1
=====================================================

SITE1/HBI0262C/images.txt
......
NOR3UPDATE: AUTO                 ;Image Update:NONE/AUTO/FORCE
NOR3ADDRESS: 0x00C00000          ;Image Flash Address
NOR3FILE: \SOFTWARE\juno-r1.dtb  ;Image File Name
NOR3NAME: board.dtb              ;Specify target filename to preserve file extension
NOR3LOAD: 00000000               ;Image Load Address
NOR3ENTRY: 00000000              ;Image Entry Point
......

Configure *.dtb in the boot configuration for Juno r2
=====================================================

SITE1/HBI0262D/images.txt
......
NOR3UPDATE: AUTO                 ;Image Update:NONE/AUTO/FORCE
NOR3ADDRESS: 0x02000000          ;Image Flash Address
NOR3FILE: \SOFTWARE\juno-r2.dtb  ;Image File Name
NOR3NAME: board.dtb              ;Specify target filename to preserve file extension
NOR3LOAD: 00000000               ;Image Load Address
NOR3ENTRY: 00000000              ;Image Entry Point
......

Installing kernel image and DTB
===============================

1. Connect to the ARM Juno UART0 and execute USB_ON in the terminal
2. Connect a USB cable between your PC and ARM Juno USB type B connector
   A mass storage device should appear in your desktop.
3. Open the software/ folder
4. Copy the 'Image' file to software/
5. Copy the 'juno-r1.dtb' (r1), 'juno.dtb' (r0) or juno-r2.dtb (r2) file to software/
6. Copy the bootloader binaries (bl1.bin and fip.bin) to software/
7. Press the red button in the front pannel of ARM Juno

At this time, the board will erase the Flash entry for each new item and
replace it with the lastest ones.
