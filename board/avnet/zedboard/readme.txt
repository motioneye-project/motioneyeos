This is the buildroot board support for the Avnet Zedboard. The Zedboard is
a development board based on the Xilinx Zynq-7000 based All-Programmable
System-On-Chip.

Zedboard information including schematics, reference designs, and manuals are
available from http://www.zedboard.org .

To boot the Zedboard using a buildroot generated image copy the following files
to the sdcard:
	zynq-zed.dtb -> devicetree.dtb
	rootfs.cpio.gz.uboot -> uramdisk.image.gz
	uImage -> uImage

