MfgTools Howto
==============

1. Build your mfgtool image

Make sure to enable the following Buildroot options:

BR2_PACKAGE_FREESCALE_IMX=y
BR2_PACKAGE_IMX_UUC=y
BR2_TARGET_ROOTFS_CPIO=y
BR2_TARGET_ROOTFS_CPIO_GZIP=y
BR2_TARGET_ROOTFS_CPIO_UIMAGE=y

Also modify your kernel configuration to have:

CONFIG_USB_GADGET=y
CONFIG_USB_MASS_STORAGE=y
CONFIG_FSL_UTP=y
CONFIG_MMC_BLOCK_MINORS=16

2. Go into the output and create the necessary folders

$ cd output
$ mkdir -p "Profiles/Linux/OS Firmware/firmware"

3. Create your XML update script named ucl2.xml

You can find a sample XML at:

$ wget https://storage.googleapis.com/boundarydevices.com/ucl2.xml \
  -O Profiles/Linux/OS\ Firmware/ucl2.xml

4. Copy the U-Boot, Kernel and initramfs images to the appropriate
folder

$ cp images/u-boot.imx images/zImage images/imx6q-sabrelite.dtb \
  images/rootfs.cpio.uboot Profiles/Linux/OS\ Firmware/firmware/

5. Copy the prebuilt binaries to be flashed

Depending on your ucl2.xml file, the sample doesn't flash anything.

6. Run the MfgTools client:

$ ./host/usr/bin/mfgtoolcli -l mmc -s uboot_defconfig=imx \
  -s dtbname=imx6q-sabrelite.dtb -s initramfs=rootfs.cpio.uboot \
  -s mmc=1 -p 1

For more information about the tools options, please read the
"Manufacturing Tool V2 Quick Start Guide.docx" documentation contained
in every mfgtools package from NXP website[1].

Note: All the above commands require your Linux host user to have
permissions to access the USB devices. Please make sure to have udev
rules that allow the user to communicate with the BootROM IDs
(Freescale USB recovery) as well as the one used for the UTP Linux
image (0x066F:0x37FF).  Using 'sudo' in front of the mfgtoolcli
command would also grant you the necessary permission but it is *not*
recommended.

Also, if your U-Boot environment doesn't include mfgtools bootargs,
make sure to set the following:

setenv bootargs "console=${console},${baudrate} g_mass_storage.stall=0 \
	g_mass_storage.removable=1 g_mass_storage.idVendor=0x066F \
	g_mass_storage.idProduct=0x37FF g_mass_storage.iSerialNumber=\"\" \
	g_mass_storage.file=/fat"

[1] http://www.nxp.com/products/software-and-tools/software-development-tools/i.mx-software-and-tools/i.mx-6-series-software-and-development-tool-resources:IMX6_SW
