#!/bin/bash -e

if [ -z "$IMG_DIR" ] || [ -z "$BOARD" ]; then
    echo "this script must be invoked from board specific mkimage.sh"
    exit 1
fi

test "root" != "$USER" && exec sudo -E $0 "$@"

function msg() {
    echo " * $1"
}

PART_START=${PART_START:-2048} # 2048 sectors = 1MB

BOOT_SRC=$IMG_DIR/boot
BOOT=$IMG_DIR/.boot
BOOT_IMG=$IMG_DIR/boot.img
BOOT_SIZE="20" # MB

ROOT_SRC=$IMG_DIR/rootfs.tar
ROOT=$IMG_DIR/.root
ROOT_IMG=$IMG_DIR/root.img
ROOT_SIZE="180" # MB

DISK_SIZE="220" # MB

COMMON_DIR=$(cd $IMG_DIR/../../../board/common; pwd)
OS_NAME=$(source $COMMON_DIR/overlay/etc/version && echo $os_short_name)

# boot filesystem
msg "creating boot loop device"
dd if=/dev/zero of=$BOOT_IMG bs=1M count=$BOOT_SIZE
loop_dev=$(losetup -f --show $BOOT_IMG)

msg "creating boot filesystem"
mkfs.vfat -F16 $loop_dev

msg "mounting boot loop device"
mkdir -p $BOOT
mount -o loop $loop_dev $BOOT

msg "copying boot filesystem contents"
cp -r $BOOT_SRC/* $BOOT
sync

msg "unmounting boot filesystem"
umount $BOOT

msg "destroying boot loop device ($loop_dev)"
losetup -d $loop_dev
sync

# root filesystem
msg "creating root loop device"
dd if=/dev/zero of=$ROOT_IMG bs=1M count=$ROOT_SIZE
loop_dev=$(losetup -f --show $ROOT_IMG)

msg "creating root filesystem"
mkfs.ext4 $loop_dev
tune2fs -O^has_journal $loop_dev

msg "mounting root loop device"
mkdir -p $ROOT
mount -o loop $loop_dev $ROOT

msg "copying root filesystem contents"
tar -xpsf $ROOT_SRC -C $ROOT

# set internal OS name, prefix and version according to env variables
if [ -f $ROOT/etc/version ]; then
    if [ -n "$THINGOS_NAME" ]; then
        msg "setting OS name to $THINGOS_NAME"
        sed -ri "s/os_name=\".*\"/os_name=\"$THINGOS_NAME\"/" $ROOT/etc/version
    fi
    if [ -n "$THINGOS_SHORT_NAME" ]; then
        msg "setting OS short name to $THINGOS_SHORT_NAME"
        sed -ri "s/os_short_name=\".*\"/os_short_name=\"$THINGOS_SHORT_NAME\"/" $ROOT/etc/version
    fi
    if [ -n "$THINGOS_PREFIX" ]; then
        msg "setting OS prefix to $THINGOS_PREFIX"
        sed -ri "s/os_prefix=\".*\"/os_prefix=\"$THINGOS_PREFIX\"/" $ROOT/etc/version
    fi
    if [ -n "$THINGOS_VERSION" ]; then
        msg "setting OS version to $THINGOS_VERSION"
        sed -ri "s/os_version=\".*\"/os_version=\"$THINGOS_VERSION\"/" $ROOT/etc/version
    fi
fi

msg "unmounting root filesystem"
umount $ROOT

msg "destroying root loop device ($loop_dev)"
losetup -d $loop_dev
sync

DISK_IMG=$IMG_DIR/disk.img
BOOT_IMG=$IMG_DIR/boot.img
ROOT_IMG=$IMG_DIR/root.img

if ! [ -r $BOOT_IMG ]; then
    echo "boot image missing"
    exit -1
fi

if ! [ -r $ROOT_IMG ]; then
    echo "root image missing"
    exit -1
fi

# disk image
msg "creating disk loop device"
dd if=/dev/zero of=$DISK_IMG bs=1M count=$DISK_SIZE
if [ -n "$UBOOT_BIN" ] && [ -n "$UBOOT_SEEK" ]; then
    msg "copying u-boot image"
    dd conv=notrunc if=$UBOOT_BIN of=$DISK_IMG bs=512 seek=$UBOOT_SEEK
fi
loop_dev=$(losetup -f --show $DISK_IMG)

msg "partitioning disk"
root_part_start=$(($PART_START + $BOOT_SIZE * 2048))
set +e
fdisk -u=sectors $loop_dev <<END
o
n
p
1
${PART_START}
+${BOOT_SIZE}M
n
p
2
${root_part_start}
+${ROOT_SIZE}M

t
1
e
a
1
w
END
set -e
sync

msg "reading partition offsets"
boot_offs=$(fdisk -u=sectors -l $loop_dev | grep -E 'loop([[:digit:]])+p1' | tr -d '*' | tr -s ' ' | cut -d ' ' -f 2)
root_offs=$(fdisk -u=sectors -l $loop_dev | grep -E 'loop([[:digit:]])+p2' | tr -d '*' | tr -s ' ' | cut -d ' ' -f 2)

msg "destroying disk loop device ($loop_dev)"
losetup -d $loop_dev

msg "creating boot loop device"
loop_dev=$(losetup -f --show -o $(($boot_offs * 512)) $DISK_IMG)

msg "copying boot image"
dd if=$BOOT_IMG of=$loop_dev
sync

msg "destroying boot loop device ($loop_dev)"
losetup -d $loop_dev

msg "creating root loop device"
loop_dev=$(losetup -f --show -o $(($root_offs * 512)) $DISK_IMG)
sync

msg "copying root image"
dd if=$ROOT_IMG of=$loop_dev
sync

msg "destroying root loop device ($loop_dev)"
losetup -d $loop_dev
sync

mv $DISK_IMG $(dirname $DISK_IMG)/$OS_NAME-$BOARD.img
DISK_IMG=$(dirname $DISK_IMG)/$OS_NAME-$BOARD.img

msg "$(realpath "$DISK_IMG") is ready"

