Technologic Systems TS-5x00 SBCs
================================

This document explains how to set up a basic Buildroot system for the
Technologic Systems TS-5x00 serie of x86-based Single Board Computers.

TS-5x00 Single Board Computers are based on the AMD Elan520 processor. For more
information please have a look at http://wiki.embeddedarm.com/wiki/#AMD

The kernel configuration works for any AMD Elan520-based SBCs, but the support
is enhanced for the TS-5500 and TS-5400 models (on-board devices registration
and additional sysfs attributes under /sys/devices/platform/).

To build the default configuration you only have to:

    $ make ts5x00_defconfig
    $ make

You will need a Compact Flash card of sufficient size and the first or only
partition configured as Linux type, with the bootable flag.

You can transfer the system on the partition then optionally resize it with:

    # dd if=output/images/rootfs.ext4 of=/dev/sdX1
    # resize2fs /dev/sdX1

Or you can just extract the root filesystem to the partition with:

    # mount /dev/sdX1 /mnt
    # tar -pxf output/images/rootfs.tar -C /mnt
    # umount /mnt

To install the bootloader, you will need to copy the MBR:

    # cat output/images/syslinux/mbr.bin > /dev/sdX

Then install SYSLINUX in the mounted partition:

    # mount /dev/sdX1 /mnt
    # output/host/sbin/extlinux --install /mnt/boot/syslinux
    # umount /mnt

IMPORTANT: In order for the board to boot the Compact Flash with a recent
config, the BIOS must use Logical Block Addressing (LBA). You can do it by
choosing "Ide 0: AUTOCONFIG, LBA" under "IDE DRIVE GEOMETRY" in the "Basic CMOS
Configuration" screen. For details about the CMOS setup, please see:
http://wiki.embeddedarm.com/wiki/TS-5500#System_BIOS_Setup_Screens

Connect a terminal program to the rs232 connector marked "COM2"
with baudrate set to 115200, insert the Compact Flash card into the socket,
power up the board, and enjoy.
