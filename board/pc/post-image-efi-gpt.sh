#!/bin/sh

set -e

cd ${BINARIES_DIR}

# GPT partition type UUIDs
esp_type=c12a7328-f81f-11d2-ba4b-00a0c93ec93b
linux_type=44479540-f297-41b2-9af7-d131d5f0458a

# Partition UUIDs
efi_part_uuid=$(uuidgen)
root_part_uuid=$(uuidgen)

# Boot partition offset and size, in 512-byte sectors
efi_part_start=64
efi_part_size=32768

# Rootfs partition offset and size, in 512-byte sectors
root_part_start=$(( efi_part_start + efi_part_size ))
root_part_size=$(( $(stat -c %s rootfs.ext2) / 512 ))

first_lba=34
last_lba=$(( root_part_start + root_part_size ))

# Disk image size in 512-byte sectors
image_size=$(( last_lba + first_lba ))

cat > efi-part/EFI/BOOT/grub.cfg <<EOF
set default="0"
set timeout="5"

menuentry "Buildroot" {
	linux /bzImage root=PARTUUID=$root_part_uuid rootwait console=tty1
}
EOF

# Create EFI system partition
rm -f efi-part.vfat
dd if=/dev/zero of=efi-part.vfat bs=512 count=0 seek=$efi_part_size
mkdosfs  efi-part.vfat
mcopy -bsp -i efi-part.vfat efi-part/startup.nsh ::startup.nsh
mcopy -bsp -i efi-part.vfat efi-part/EFI ::EFI
mcopy -bsp -i efi-part.vfat bzImage ::bzImage

rm -f disk.img
dd if=/dev/zero of=disk.img bs=512 count=0 seek=$image_size

sfdisk disk.img <<EOF
label: gpt
label-id: $(uuidgen)
device: /dev/foobar0
unit: sectors
first-lba: $first_lba
last-lba: $last_lba

/dev/foobar0p1 : start=$efi_part_start,  size=$efi_part_size,  type=$esp_type,   uuid=$efi_part_uuid,  name="efi-part.vfat"
/dev/foobar0p2 : start=$root_part_start, size=$root_part_size, type=$linux_type, uuid=$root_part_uuid, name="rootfs.ext2"
EOF

dd if=efi-part.vfat of=disk.img bs=512 count=$efi_part_size seek=$efi_part_start conv=notrunc
dd if=rootfs.ext2   of=disk.img bs=512 count=$root_part_size seek=$root_part_start conv=notrunc
