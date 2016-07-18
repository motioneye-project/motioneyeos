This is the buildroot board support for the Avnet Zedboard. The Zedboard is
a development board based on the Xilinx Zynq-7000 based All-Programmable
System-On-Chip.

Zedboard information including schematics, reference designs, and manuals are
available from http://www.zedboard.org .

Steps to create a working system for Zedboard:

1) make zynq_zed_defconfig
2) make
3) All needed files will be available in the output/images directory.
   Create a FAT32 partition at the beginning of your SD Card and copy files:
     - boot.bin
     - u-boot.img
     - uImage
     - uramdisk.image.gz (should be renamed from rootfs.cpio.uboot)
     - devicetree.dtb (should be renamed from zynq-zed.dtb)
   into your SD card
4) boot your Zedboard

You can alter the booting procedure by creating a file uEnv.txt
in the root of the SD card. It is a plain text file in format
<key>=<value> one per line:

kernel_image=myimage
modeboot=myboot
myboot=...
