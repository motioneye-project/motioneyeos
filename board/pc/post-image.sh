#!/bin/sh

BOARD_DIR="$(dirname $0)"

# Detect boot strategy, EFI or BIOS
if [ -f ${BINARIES_DIR}/efi-part/startup.nsh ]; then
  cp -f ${BOARD_DIR}/grub-efi.cfg ${BINARIES_DIR}/efi-part/EFI/BOOT/grub.cfg
else
  cp -f ${BOARD_DIR}/grub-bios.cfg ${TARGET_DIR}/boot/grub/grub.cfg
  # Copy grub 1st stage to binaries, required for genimage
  cp -f ${HOST_DIR}/lib/grub/i386-pc/boot.img ${BINARIES_DIR}
fi

exit $?
