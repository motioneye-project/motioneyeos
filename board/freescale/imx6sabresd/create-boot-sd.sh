#!/bin/sh

set -u
set -e

PROGNAME=$(basename $0)

usage()
{
    echo "Create an SD card that boots on an i.MX53/6 board."
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

# Unmount the partitions if mounted
umount ${PART1} || true
umount ${PART2} || true

# First, clear the card
dd if=/dev/zero of=${DEV} bs=1M count=20

sync

# Partition the card.
# SD layout for i.MX6 boot:
# - Bootloader at offset 1024
# - FAT partition starting at 1MB offset, containing uImage and *.dtb
# - ext2/3 partition formatted as ext2 or ext3, containing the root filesystem.
sfdisk ${DEV} <<EOF
32,480,b
512,,L
EOF

sync

# Copy the bootloader at offset 1024
dd if=output/images/u-boot.imx of=${DEV} obs=512 seek=2

# Prepare a temp dir for mounting partitions
TMPDIR=$(mktemp -d)

# FAT partition: kernel and DTBs
mkfs.vfat ${PART1}
mount ${PART1} ${TMPDIR}
cp output/images/*Image ${TMPDIR}/
cp output/images/*.dtb  ${TMPDIR}/ || true
sync
umount ${TMPDIR}

# ext2 partition: root filesystem
mkfs.ext2 ${PART2}
mount ${PART2} ${TMPDIR}
tar -C ${TMPDIR}/ -xf output/images/rootfs.tar
sync
umount ${TMPDIR}

# Cleanup
rmdir ${TMPDIR}
sync
echo Done
