#!/bin/sh

set -u
set -e

PROGNAME=$(basename $0)

usage()
{
    echo "Create an SD card that boots on an i.MX28 EVK board."
    echo
    echo "Note: all data on the the card will be completely deleted!"
    echo "Use with care!"
    echo "Superuser permissions may be required to write to the device."
    echo
    echo "Usage: ${PROGNAME} <sd_block_device>"
    echo "Arguments:"
    echo "  <sd_block_device>     The device to be written to"
    echo
    echo "Example: ${PROGNAME} /dev/mmcblk0"
    echo
}

if [ $# -ne 1 ]; then
    usage
    exit 1
fi

if [ $(id -u) -ne 0 ]; then
    echo "${PROGNAME} must be run as root"
    exit 1
fi

DEV=${1}

# The partition name prefix depends on the device name:
# - /dev/sde -> /dev/sde1
# - /dev/mmcblk0 -> /dev/mmcblk0p1
if echo ${DEV}|grep -q mmcblk ; then
    PART="p"
else
    PART=""
fi

PART1=${DEV}${PART}1
PART2=${DEV}${PART}2
PART3=${DEV}${PART}3

# Unmount the partitions if mounted
umount ${PART1} || true
umount ${PART2} || true
umount ${PART3} || true

# First, clear the card
dd if=/dev/zero of=${DEV} bs=1M count=20

sync

# Partition the card.
# SD layout for i.MX28 boot:
# - Special partition type 53 at sector 2048, containing an SD-SB-encapsulated u-boot
# - FAT partition containing zImage
# - ext2/3 partition formatted as ext2 or ext3, containing the root filesystem.
sfdisk --force -u S ${DEV} <<EOF
2048,2000,53
4048,16000,b
20048,,L
EOF

sync

# Copy the bootloader at offset 2048
# (We need to skip the partition table in the .sd, too.)
dd if=output/images/u-boot.sd of=${DEV}1 bs=1M

# Prepare a temp dir for mounting partitions
TMPDIR=$(mktemp -d)
 
# FAT partition: kernel
mkfs.vfat ${PART2}
mount ${PART2} ${TMPDIR}
cp output/images/*Image ${TMPDIR}/
cp output/images/*.dtb  ${TMPDIR}/ || true
sync
umount ${TMPDIR}

# ext2 partition: root filesystem
mkfs.ext2 ${PART3}
mount ${PART3} ${TMPDIR}
tar -C ${TMPDIR}/ -xf output/images/rootfs.tar
sync
umount ${TMPDIR}

# Cleanup
rmdir ${TMPDIR}
sync
echo Done
