#!/bin/sh

# Detect boot strategy, EFI or BIOS
if [ -f ${BINARIES_DIR}/efi-part/startup.nsh ]; then
  BOOT_TYPE=efi
  # grub.cfg needs customization for EFI since the root partition is
  # number 2, and bzImage is in the EFI partition (1)
  cat >${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg <<__EOF__
set default="0"
set timeout="5"

menuentry "Buildroot" {
	linux /bzImage root=/dev/sda2 rootwait console=tty1
}
__EOF__
else
  BOOT_TYPE=bios
  # Copy grub 1st stage to binaries, required for genimage
  cp -f ${HOST_DIR}/usr/lib/grub/i386-pc/boot.img ${BINARIES_DIR}
fi

BOARD_DIR="$(dirname $0)"
GENIMAGE_CFG="${BOARD_DIR}/genimage-${BOOT_TYPE}.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

rm -rf "${GENIMAGE_TMP}"

genimage                           \
       --rootpath "${TARGET_DIR}"     \
       --tmppath "${GENIMAGE_TMP}"    \
       --inputpath "${BINARIES_DIR}"  \
       --outputpath "${BINARIES_DIR}" \
       --config "${GENIMAGE_CFG}"

exit $?
