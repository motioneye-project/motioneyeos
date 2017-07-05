#!/bin/sh

# This script creates u-boot FIT image containing the kernel and the DT,
# then signs it using futility from vboot-utils.
# The resulting file is called uImage.kpart.

BOARD_DIR=$(dirname $0)
mkimage=$HOST_DIR/bin/mkimage
futility=$HOST_DIR/bin/futility
devkeys=$HOST_DIR/share/vboot/devkeys

run() { echo "$@"; "$@"; }
die() { echo "$@" >&2; exit 1; }
test -f $BINARIES_DIR/zImage || \
	die "No kernel image found"
test -x $mkimage || \
	die "No mkimage found (host-uboot-tools has not been built?)"
test -x $futility || \
	die "No futility found (host-vboot-utils has not been built?)"

# kernel.its references zImage and exynos5250-snow.dtb, and all three
# files must be in current directory for mkimage.
run cp $BOARD_DIR/kernel.its $BINARIES_DIR/kernel.its || exit 1
echo "# entering $BINARIES_DIR for the next command"
(cd $BINARIES_DIR && run $mkimage -f kernel.its uImage.itb) || exit 1

# futility requires non-empty file to be supplied with --bootloader
# even if it does not make sense for the target platform.
echo > $BINARIES_DIR/dummy.txt

run $futility vbutil_kernel \
	--keyblock $devkeys/kernel.keyblock \
	--signprivate $devkeys/kernel_data_key.vbprivk \
	--arch arm \
	--version 1 \
	--config $BOARD_DIR/kernel.args \
	--vmlinuz $BINARIES_DIR/uImage.itb \
	--bootloader $BINARIES_DIR/dummy.txt \
	--pack $BINARIES_DIR/uImage.kpart || exit 1

rm -f $BINARIES_DIR/kernel.its $BINARIES_DIR/dummy.txt
