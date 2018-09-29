Bare PC sample config
=====================

1. Build

  First select the appropriate target you want.

  For BIOS-based boot strategy:

  $ make pc_x86_64_bios_defconfig

  For EFI-based boot strategy on a GPT-partitioned disk:

  $ make pc_x86_64_efi_defconfig

  Add any additional packages required and build:

  $ make

2. Write the pendrive

  The build process will create a pendrive image called sdcard.img in
  output/images.

  Write the image to a pendrive:

  $ dd if=output/images/disk.img of=/dev/sdc; sync

  Once it's done insert it into the target PC and boot.

  Remember that if said PC has another boot device you might need to
  select this alternative for it to boot.

  In the case of EFI boot you might need to disable Secure Boot from
  the setup as well.

3. Enjoy

Emulation in qemu (BIOS)
========================

1. Edit grub-bios.cfg

  Since the driver will show up in the virtual machine as /dev/vda,
  change board/pc/grub-bios.cfg to use root=/dev/vda2 instead of
  root=/dev/sda2. Then rebuild grub2 and the image.

2. Run the emulation with:

qemu-system-x86_64 \
	-M pc \
	-drive file=output/images/disk.img,if=virtio,format=raw \
	-net nic,model=virtio \
	-net user


Emulation in qemu (UEFI)
========================

1. Edit grub-efi.cfg

  Since the driver will show up in the virtual machine as /dev/vda,
  change board/pc/grub-efi.cfg to use root=/dev/vda2 instead of
  root=/dev/sda2. Then rebuild grub2 and the image.

2. Run the emulation with:

qemu-system-x86_64 \
	-M pc \
	-bios </path/to/OVMF_CODE.fd> \
	-drive file=output/images/disk.img,if=virtio,format=raw \
	-net nic,model=virtio \
	-net user

Note that </path/to/OVMF.fd> needs to point to a valid x86_64 UEFI
firmware image for qemu. It may be provided by your distribution as a
edk2 or OVMF package, in path such as
/usr/share/edk2/ovmf/OVMF_CODE.fd .
