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

Uboot Support
-------------

Uboot is installed in a wrapper file called BOOT.BIN located on the root of
the SD card.  To create the BOOT.BIN file do the following.

source <path/to/xilinx/settings.sh>
cat <<EOF > boot.bif
{
   [bootloader]<path/to/fsbl.elf>
   <path/to/system.bit>
   <path/to/uboot.elf>
}
EOF
bootgen -image boot.bif -o i BOOT.BIN
