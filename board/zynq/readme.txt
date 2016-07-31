This is the Buildroot support for Zynq boards.  Zynq boards are available from
Xilinx and some third party vendors, but the build procedure is very similar.

Currently, three boards are natively supported by Buildroot:
 - Xilinx ZC706 board (zynq_zc706_defconfig)
 - Avnet ZedBoard (zynq_zed_defconfig)
 - Avnet MicroZed (zynq_microzed_defconfig)

The following build procedure focuses on them, but you can adjust it to your
board even if it is not listed above.  Major Zynq-based boards are supported by
U-Boot, and their Device Trees are merged in Linux Kernel.  If your board is the
case, booting the kernel is a piece of cake.  All you need to do is to change:
 - Kernel Device Tree file name (BR2_LINUX_KERNEL_INTREE_DTS_NAME)
 - U-Boot board defconfig (BR2_TARGET_UBOOT_BOARD_KCONFIG)

Steps to create a working system for a Zynq board:

1) Configuration (do one of the following)
    make zynq_zc706_defconfig     (ZC706)
    make zynq_zed_defconfig       (Zedboard)
    make zynq_microzed_defconfig  (MicroZed)
2) make
3) All needed files will be available in the output/images directory.
   Create a FAT32 partition at the beginning of your SD Card and copy files:
     - boot.bin
     - u-boot.img
     - uImage
     - uramdisk.image.gz (should be renamed from rootfs.cpio.uboot)
     - devicetree.dtb (should be renamed from zynq-***.dtb)
   into your SD card
4) boot your board

You can alter the booting procedure by creating a file uEnv.txt
in the root of the SD card. It is a plain text file in format
<key>=<value> one per line:

kernel_image=myimage
modeboot=myboot
myboot=...

Note:
The DTB for MicroZed is the same as the one for the Zedboard (zynq-zed.dtb),
and this is the recommended solution, see
https://forums.xilinx.com/t5/Embedded-Linux/Microzed-default-device-tree-dts/td-p/432856.

References:
 - ZC706 information including schematics, reference designs, and manuals are
   available from
   http://www.xilinx.com/products/boards-and-kits/ek-z7-zc706-g.html.

 - Zedboard/Microzed information including schematics, reference designs, and
   manuals are available from http://www.zedboard.org .
