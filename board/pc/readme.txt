Bare PC sample config
=====================

1. Build

  First select the appropriate target you want.

  For BIOS-based boot strategy:

  $ make pc_x86_64_bios_defconfig

  Or for EFI:

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
