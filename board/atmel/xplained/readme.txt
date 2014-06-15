Atmel SAMA5D3 Xplained board
============================

This document explains how to set up a basic Buildroot system on the
Atmel SAMA5D3 Xplained board, whose main site is
http://www.atmel.com/tools/ATSAMA5D3-XPLD.aspx. Additional details can
also be found on the http://www.at91.com/linux4sam/bin/view/Linux4SAM/
web site.

Note that the default Buildroot configuration is prepared to boot from
an SD card: the first stage bootloader, second stage bootloader,
kernel image and root filesystem are all located on the SD card. Some
adjustements in the bootloader configuration will be needed to boot
from NAND flash.

Configuring and building Buildroot
----------------------------------

  make atmel_xplained_defconfig
  make

Preparing the SD card
---------------------

The SD card must be partitionned with at least two partitions: one
FAT16 partition for the bootloaders, kernel image and Device Tree
blob, and one ext4 partition for the root filesystem. To partition the
SD card:

sudo sfdisk -uM /dev/mmcblk0 <<EOF
,64,6
;
EOF

This creates a 64 MB partition for the FAT16 filesystem (type 6) and
uses the rest for the ext4 filesystem used for the root filesystem.

Then, format both partitions:

sudo mkfs.msdos -n boot /dev/mmcblk0p1
sudo mkfs.ext4 -L rootfs -O ^huge_file /dev/mmcblk0p2

 Note: the -O ^huge_file option is needed to avoid enabling the huge
 files features of ext4 (to support files larges than 2 TB), which
 needs the kernel option CONFIG_LBDAF to be enabled.

Mount both partitions (if not done automatically by your system):

sudo mount /dev/mmcblk0p1 /media/boot
sudo mount /dev/mmcblk0p2 /media/rootfs

Copy the bootloaders, kernel image and Device Tree blob to the first
partition:

cp output/images/sama5d3_xplained-sdcardboot-uboot-3.6.2.bin /media/boot/boot.bin
cp output/images/u-boot.bin /media/boot/u-boot.bin
cp output/images/zImage /media/boot/zImage
cp output/images/at91-sama5d3_xplained.dtb /media/boot/at91-sama5d3_xplained.dtb

Extract the root filesystem to the second partition:

sudo tar -C /media/rootfs -xf output/images/rootfs.tar

Unmount both partitions:

sudo umount /media/boot
sudo umount /media/rootfs

Insert your SD card in your Xplained board, and enjoy. The default
U-Boot environment will properly load the kernel and Device Tree blob
from the first partition of the SD card, so everything works
automatically.

