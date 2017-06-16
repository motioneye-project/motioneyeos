Openblocks A6

Intro
=====

This default configuration will allow you to start experimenting with the
buildroot environment for the Openblocks A6. With the current configuration
it will bring-up the board, and allow access through the serial console.

How to build it
===============

Configure Buildroot:

    $ make openblocks_a6_defconfig

Compile everything:

    $ make

Updating board over TFTP
========================

Copy the content of output/images to the root of your TFTP server.

Connect serial and ethernet, power up board and stop it in U-Boot:

DRAM (DDR2) CAS Latency = 5 tRP = 5 tRAS = 14 tRCD=5
DRAM CS[0] base 0x00000000   size 512MB
DRAM Total size 512MB  16bit width
Addresses 8M - 0M are saved for the U-Boot usage.
Mem malloc Initialization (8M - 7M): Done
NAND:64 MB
POST:  mac verify Eth0 PASSED

CPU : Marvell Feroceon (Rev 1)

Streaming disabled
Write allocate disabled


USB 0: host mode
Net:   egiga0
Hit any key to stop autoboot:  0
openblocks>>


Load kernel from tftp:

setenv serverip <tftp-server-ip>
setenv bootfile uImage.kirkwood-openblocks_a6
bootp && tftp


Write it to nand:

nand erase 0x590000 0x1c5c000
nand write.e $loadaddr 0x590000 0x1c5c000


Load rootfs from tftp:

setenv serverip <tftp-server-ip>
setenv bootfile rootfs.jffs2
bootp && tftp


Write it to nand:

nand erase 0x2214000 0x1dc4000
nand write.jffs2 $loadaddr 0x2214000 0x1dc4000


Configure kernel to use rootfs:

setenv root /dev/mtdblock5 rootfstype=jffs2
saveenv
boot
