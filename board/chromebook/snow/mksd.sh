#!/bin/sh

# This scripts makes a minimal bootable SD card image for the Chromebook.
# The resulting file is called bootsd.img. It should be written directly
# to the card:
#
#	SD=/dev/mmcblk1		# check your device name!
#	dd if=output/images/bootsd.img of=$SD
#
# The partitions are created just large enough to hold the kernel and
# the rootfs image. Most of the card will be empty, and the secondary
# GPT will not be in its proper location.

# cgpt does not create protective MBR, and the kernel refuses to read
# GPT unless there's some kind of MBR in sector 0. So we need parted
# to write that single sector before doing anything with the GPT.
cgpt=$HOST_DIR/usr/bin/cgpt
parted=$HOST_DIR/usr/sbin/parted
kernel=$BINARIES_DIR/uImage.kpart
rootfs=$BINARIES_DIR/rootfs.ext2

run() { echo "$@"; "$@"; }
die() { echo "$@" >&2; exit 1; }
test -f $kernel || die "No kernel image found"
test -f $rootfs || die "No rootfs image found"
test -x $cgpt || die "cgpt not found (host-vboot-utils have not been built?)"

# True file sizes in bytes
kernelsize=`stat -t $kernel | cut -d\  -f2`
rootfssize=`stat -t $rootfs | cut -d\  -f2`

# The card is partitioned in sectors of 8KB.
# 4 sectors are reserved for MBR+GPT. Their actual size turns out
# to be 33 512-blocks which is just over 2 sectors, but we align
# it to a nice round number.
sec=8192
kernelsec=$(((kernelsize+8191)>>13))
rootfssec=$(((rootfssize+8191)>>13))
headersec=4

# There is also a copy of MBR+GPT at the end of the image.
# It's going to be useless but both tools assume it's there.
imagesec=$((2*headersec+kernelsec+rootfssec))
bootsd="$BINARIES_DIR/bootsd.img"
run dd bs=$sec count=$imagesec if=/dev/zero of=$bootsd

# cgpt needs offsets and sizes in 512-blocks.
block=512
kernelstart=$((headersec<<4))
kernelblocks=$((kernelsec<<4))
rootfsblocks=$((rootfssec<<4))
rootfsstart=$((kernelstart+kernelblocks))

# This command initializes both GPT and MBR
run $parted -s $bootsd mklabel gpt

# The kernel partition must be marked as bootable, that's why -S -T -P
run $cgpt add -i 1 -b $kernelstart -s $kernelblocks \
	-t kernel -l kernel \
	-S 1 -T 1 -P 10 $bootsd

# It does not really matter where the rootfs partition is located as long
# as the kernel can find it.
# However, if anything is changed here, kernel.args must be updated as well.
run $cgpt add -i 2 -b $rootfsstart -s $rootfsblocks \
	-t data -l rootfs $bootsd

run dd bs=$block if=$kernel of=$bootsd seek=$kernelstart
run dd bs=$block if=$rootfs of=$bootsd seek=$rootfsstart
