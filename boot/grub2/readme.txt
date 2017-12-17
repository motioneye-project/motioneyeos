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

Notes on using Grub2 for EFI-based platforms
============================================

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

To test your EFI image in Qemu
------------------------------

1. Download the EFI BIOS for Qemu
   Version IA32 or X64 depending on the chosen Grub2
   platform (i386-efi vs. x86-64-efi)
   http://sourceforge.net/projects/edk2/files/OVMF/
2. Extract, and rename OVMF.fd to bios.bin and
   CirrusLogic5446.rom to vgabios-cirrus.bin.
3. qemu-system-{i386,x86-64} -L ovmf-dir/ -hda disk.img
4. Make sure to pass pci=nocrs to the kernel command line,
   to workaround a bug in the EFI BIOS regarding the
   EFI framebuffer.
