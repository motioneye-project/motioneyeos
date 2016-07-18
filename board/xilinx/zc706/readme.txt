This is the Buildroot board support for the Xilinx ZC706. The ZC706 is
a development board based on the Xilinx Zynq-7000 based
All-Programmable System-On-Chip.

ZC706 information including schematics, reference designs, and manuals
are available from
http://www.xilinx.com/products/boards-and-kits/ek-z7-zc706-g.html.

Steps to create a working system for ZC706 board:

1) make zynq_zc706_defconfig
2) make
3) All needed files will be available in the output/images directory.
   Create a FAT32 partition at the beginning of your SD Card and copy files:
     - boot.bin
     - u-boot.img
     - uImage
     - uramdisk.image.gz (should be renamed from rootfs.cpio.uboot)
     - devicetree.dtb (should be renamed from zynq-zc706.dtb)
   into your SD card
4) boot your ZC706 board

You can alter the booting procedure by creating a file uEnv.txt
in the root of the SD card. It is a plain text file in format
<key>=<value> one per line:

kernel_image=myimage
modeboot=myboot
myboot=...
