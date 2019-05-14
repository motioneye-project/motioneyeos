Notes on using Grub2 for BIOS-based platforms
=============================================

1. Create a disk image
   dd if=/dev/zero of=disk.img bs=1M count=32
2. Partition it (either legacy or GPT style partitions work)
   cfdisk disk.img
    - Create one partition, type Linux, for the root
      filesystem. The only constraint is to make sure there
      is enough free space *before* the first partition to
      store Grub2. Leaving 1 MB of free space is safe.
3. Setup loop device and loop partitions
   sudo losetup -f disk.img
   sudo partx -a /dev/loop0
4. Prepare the root partition
   sudo mkfs.ext3 -L root /dev/loop0p1
   sudo mount /dev/loop0p1 /mnt
   sudo tar -C /mnt -xf output/images/rootfs.tar
   sudo umount /mnt
5. Install Grub2
   sudo ./output/host/sbin/grub-bios-setup \
        -b ./output/host/lib/grub/i386-pc/boot.img \
        -c ./output/images/grub.img -d . /dev/loop0
6. Cleanup loop device
   sudo partx -d /dev/loop0
   sudo losetup -d /dev/loop0
7. Your disk.img is ready!

Using genimage
--------------

If you use genimage to generate your complete image,
installing Grub can be tricky. Here is how to achieve Grub's
installation with genimage:

partition boot {
    in-partition-table = "no"
    image = "path_to_boot.img"
    offset = 0
    size = 512
}
partition grub {
    in-partition-table = "no"
    image = "path_to_grub.img"
    offset = 512
}

The result is not byte to byte identical to what
grub-bios-setup does but it works anyway.

To test your BIOS image in Qemu
-------------------------------

qemu-system-{i386,x86-64} -hda disk.img

Notes on using Grub2 for x86/x86_64 EFI-based platforms
=======================================================

1. Create a disk image
   dd if=/dev/zero of=disk.img bs=1M count=32
2. Partition it with GPT partitions
   cgdisk disk.img
    - Create a first partition, type EF00, for the
      bootloader and kernel image
    - Create a second partition, type 8300, for the root
      filesystem.
3. Setup loop device and loop partitions
   sudo losetup -f disk.img
   sudo partx -a /dev/loop0
4. Prepare the boot partition
   sudo mkfs.vfat -n boot /dev/loop0p1
   sudo mount /dev/loop0p1 /mnt
   sudo cp -a output/images/efi-part/* /mnt/
   sudo cp output/images/bzImage /mnt/
   sudo umount /mnt
5. Prepare the root partition
   sudo mkfs.ext3 -L root /dev/loop0p2
   sudo mount /dev/loop0p2 /mnt
   sudo tar -C /mnt -xf output/images/rootfs.tar
   sudo umount /mnt
6  Cleanup loop device
   sudo partx -d /dev/loop0
   sudo losetup -d /dev/loop0
7. Your disk.img is ready!

To test your i386/x86-64 EFI image in Qemu
------------------------------------------

1. Download the EFI BIOS for Qemu
   Version IA32 or X64 depending on the chosen Grub2
   platform (i386-efi vs. x86-64-efi)
   https://www.kraxel.org/repos/jenkins/edk2/
   (or use one provided by your distribution as OVMF)
2. Extract, and rename OVMF.fd to bios.bin and
   CirrusLogic5446.rom to vgabios-cirrus.bin.
3. qemu-system-{i386,x86-64} -L ovmf-dir/ -hda disk.img
4. Make sure to pass pci=nocrs to the kernel command line,
   to workaround a bug in the EFI BIOS regarding the
   EFI framebuffer.

Notes on using Grub2 for ARM u-boot-based platforms
===================================================

The following steps show how to use the Grub2 arm-uboot platform
support in the simplest way possible and with a single
buildroot-generated filesystem.

 1. Load qemu_arm_vexpress_defconfig

 2. Enable u-boot with the vexpress_ca9x4 board name and with
    u-boot.elf image format.

 3. Enable grub2 for the arm-uboot platform.

 4. Enable "Install kernel image to /boot in target" in the kernel
    menu to populate a /boot directory with zImage in it.

 5. The upstream u-boot vexpress_ca9x4 doesn't have CONFIG_API enabled
    by default, which is required.

    Before building, patch u-boot (for example, make u-boot-extract to
    edit the source before building) file
    include/configs/vexpress_common.h to define:

    #define CONFIG_API
    #define CONFIG_SYS_MMC_MAX_DEVICE   1

 6. Create a custom grub2 config file with the following contents and
    set its path in BR2_TARGET_GRUB2_CFG:

    set default="0"
    set timeout="5"

    menuentry "Buildroot" {
        set root='(hd0)'
        linux /boot/zImage root=/dev/mmcblk0 console=ttyAMA0
        devicetree /boot/vexpress-v2p-ca9.dtb
    }

 7. Create a custom builtin config file with the following contents
    and set its path in BR2_TARGET_GRUB2_BUILTIN_CONFIG:

    set root=(hd0)
    set prefix=/boot/grub

 8. Create a custom post-build script which copies files from
    ${BINARIES_DIR}/boot-part to $(TARGET_DIR)/boot (set its path in
    BR2_ROOTFS_POST_BUILD_SCRIPT):

    #!/bin/sh
    cp -r ${BINARIES_DIR}/boot-part/* ${TARGET_DIR}/boot/

 9. make

10. Run qemu with:

    qemu-system-arm -M vexpress-a9 -kernel output/images/u-boot -m 1024 \
    -nographic -sd output/images/rootfs.ext2

11. In u-boot, stop at the prompt and run grub2 with:

  => ext2load mmc 0:0 ${loadaddr} /boot/grub/grub.img
  => bootm

12. This should bring the grub2 menu, upon which selecting the "Buildroot"
    entry should boot Linux.


Notes on using Grub2 for Aarch64 EFI-based platforms
====================================================

The following steps show how to use the Grub2 arm64-efi platform,
using qemu and EFI firmware built for qemu.

 1. Load aarch64_efi_defconfig

 2. make

 3. Download the EFI firmware for qemu aarch64
    https://www.kraxel.org/repos/jenkins/edk2/
    (or use one provided by your distribution as OVMF-aarch64 or AAVMF)

 4. Run qemu with:

    qemu-system-aarch64 -M virt -cpu cortex-a57 -m 512 -nographic \
    -bios <path/to/EDK2>/QEMU_EFI.fd -hda output/images/disk.img \
    -netdev user,id=eth0 -device virtio-net-device,netdev=eth0

 5. This should bring the grub2 menu, upon which selecting the
    "Buildroot" entry should boot Linux.
