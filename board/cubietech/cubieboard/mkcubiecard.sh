#! /bin/sh
# mkCubieCard.sh v0.1:
# 2013, Carlo Caione <carlo.caione@gmail.com>
# heavely based on :
# mkA10card.sh v0.1
# 2012, Jason Plum <jplum@archlinuxarm.org>
# loosely based on :
# mkcard.sh v0.5
# (c) Copyright 2009 Graeme Gregory <dp@xora.org.uk>
# Licensed under terms of GPLv2
#
# Parts of the procudure base on the work of Denys Dmytriyenko
# http://wiki.omap.com/index.php/MMC_Boot_Format

IMAGES_DIR=$1
SPL_IMG=$IMAGES_DIR/sunxi-spl.bin
SPL_UBOOT=$IMAGES_DIR/u-boot-sunxi-with-spl.bin
UBOOT_IMG=$IMAGES_DIR/u-boot.bin
UIMAGE=$IMAGES_DIR/uImage
BIN_BOARD_FILE=$IMAGES_DIR/script.bin
ROOTFS=$IMAGES_DIR/rootfs.tar
BOOT_CMD_H=$IMAGES_DIR/boot.scr

export LC_ALL=C

if [ $# -ne 2 ]; then
	echo "Usage: $0 <images_dir> <drive>"
	exit 1;
fi

if [ `id -u` -ne 0 ]; then
	echo "This script must be run as root" 1>&2
	exit 1
fi

if [ ! -f $SPL_IMG  -a ! -f $SPL_UBOOT ] ||
   [ ! -f $UBOOT_IMG ] ||
   [ ! -f $UIMAGE ] ||
   [ ! -f $BIN_BOARD_FILE ] ||
   [ ! -f $ROOTFS ] ||
   [ ! -f $BOOT_CMD_H ]; then
	echo "File(s) missing."
	exit 1
fi

DRIVE=$2
P1=`mktemp -d`
P2=`mktemp -d`

dd if=/dev/zero of=$DRIVE bs=1M count=3

SIZE=`fdisk -l $DRIVE | grep Disk | grep bytes | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes


# ~2048, 16MB, FAT, bootable
# ~rest of drive, Ext4
{
echo 32,512,0x0C,*
echo 544,,,-
} | sfdisk -D $DRIVE

sleep 1

if [ -b ${DRIVE}1 ]; then
	D1=${DRIVE}1
	umount ${DRIVE}1
	mkfs.vfat -n "boot" ${DRIVE}1
else
	if [ -b ${DRIVE}p1 ]; then
		D1=${DRIVE}p1
		umount ${DRIVE}p1
		mkfs.vfat -n "boot" ${DRIVE}p1
	else
		echo "Cant find boot partition in /dev"
		exit 1
	fi
fi


if [ -b ${DRIVE}2 ]; then
	D2=${DRIVE}2
	umount ${DRIVE}2
	mkfs.ext4 -L "Cubie" ${DRIVE}2
else
	if [ -b ${DRIVE}p2 ]; then
		D2=${DRIVE}p2
		umount ${DRIVE}p2
		mkfs.ext4 -L "Cubie" ${DRIVE}p2
	else
		echo "Cant find rootfs partition in /dev"
		exit 1
	fi
fi

mount $D1 $P1
mount $D2 $P2

# write uImage
cp $UIMAGE $P1
# write board file
cp $BIN_BOARD_FILE $P1
# write u-boot script
cp $BOOT_CMD_H $P1
# write rootfs
tar -C $P2 -xvf $ROOTFS

sync

umount $D1
umount $D2

rm -fr $P1
rm -fr $P2

if [ -e $SPL_UBOOT ]; then
	dd if=$SPL_UBOOT of=$DRIVE bs=1024 seek=8
else
	# write SPL
	dd if=$SPL_IMG of=$DRIVE bs=1024 seek=8
	# write mele u-boot
	dd if=$UBOOT_IMG of=$DRIVE bs=1024 seek=32
fi
