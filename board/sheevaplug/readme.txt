Sheevaplug
==========

Once the build process is finished you will have the following files
in the output/images/ directory:

- u-boot.kwb
- uImage.kirkwood-sheevaplug
- rootfs.jffs2

Copy these to a TFTP server, connect ethernet and mini-USB cable and
power up the board. Stop the board in U-Boot and update U-Boot by
executing:

setenv serverip <ipaddress-of-tftp-server>
setenv bootfile <path/to/u-boot.kwb>
bootp
nand erase 0x0 0x80000
nand write $fileaddr 0x0 0x80000
reset

Once the new U-Boot boots up, stop it again and update Linux kernel
and rootfs by:

setenv serverip <ipaddress-of-tftp-server>
setenv bootfile <path/to/uImage.kirkwood-sheevaplug>
bootp
nand erase.part kernel
nand write $fileaddr kernel 0x400000

setenv bootfile <path/to/rootfs.jffs2>
bootp
nand erase.part rootfs
nand write $fileaddr rootfs $filesize

reset
