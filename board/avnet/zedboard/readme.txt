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
	boot.bin -> boot.bin

U-Boot SPL Support
-------------

Due to licensing issues, the files ps7_init.c/h are not able to be
distributed with the U-Boot source code.  These files are required to make a
boot.bin file.

If you already have the Xilinx tools installed, the follwing sequence will
unpack, patch and build the rfs, kernel, uboot, and uboot-spl.

make zedboard_defconfig
make uboot-patch
cp ${XILINX}/ISE_DS/EDK/sw/lib/hwplatform_templates/zed_hw_platform/ps7_init.{c,h} \
output/build/uboot-xilinx-v2014.1/boards/xilinx/zynq/
make

