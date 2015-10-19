VIA VAB-820/AMOS-820
====================

This file documents the Buildroot support for the VIA VAB-820 board and
VIA AMOS-820 system, which are built around a Freescale i.MX6 Quad/Dual SoC.
The kernel and u-boot is based on the official VIA BSP, which is in turn
based on the Freescale Linux 3.10.17_1.0.0_ga BSP.


Configuring and building Buildroot
----------------------------------

Start from the defconfig:

  $ make via_imx6_vab820_defconfig

You can edit build options the usual way:

  $ make menuconfig

When you are happy with the setup, run:

  $ make

The result of the build with the default settings should be these files:

  output/images
  ├── boot.vfat
  ├── imx6q-vab820.dtb
  ├── rootfs.ext2
  ├── rootfs.ext4 -> rootfs.ext2
  ├── rootfs.tar
  ├── sdcard.img
  ├── u-boot.imx
  └── uImage

Copy the bootable `sdcard.img` onto an SD card with "dd":

  $ sudo dd if=output/images/sdcard.img of=/dev/sdX bs=1M conv=fsync

where "sdX" is the appropriate partition of your card.

For details about the medium image layout, see the definition in
`board/via/imx6_vab820/genimage.cfg`.


Setting up your SD card manually
--------------------------------

*Important*: pay attention which partition you are modifying so you don't
accidentally erase the wrong file system, e.g your host computer or your
external storage!

In the default setup you need to create 2 partitions on your SD card:
a boot partition and a root partition. In this guide and in the default u-boot
settings the boot partition is vfat, while the root partition is ext4.

You also need to leave space for u-boot at the beginning of the card, before
all the partitions.

For example, if your SD card is at /dev/sdX, using fdisk, and starting from
an empty card, the steps are along these lines:

  # fdisk /dev/sdX
  n         (new partition)
  p         (primary partition)
  1	    (first partition)
  <return>  (default first sector, should be at least 1MB from the beginning
             which is 2048 sectors if the sector size is 512KB)
  +50M      (50MB size, as an example)
  t         (switch partition type)
  b         (select "W95 FAT32" type)
  n         (the second partition)
  p         (primary partition)
  2	    (second partition)
  <return>  (default first sector)
  <return>  (use all remaining space)
  p         (print so the partition looks something like this below)
    Device     Boot  Start      End  Sectors  Size Id Type
    /dev/sdX1         2048   104447   102400   50M  b W95 FAT32
    /dev/sdX2       104448 15564799 15460352  7.4G 83 Linux
  w         (save changes)

After this you need to format the newly created file system:

  # mkfs.vfat -L boot /dev/sdX1
  # mkfs.ext4 -L rootfs /dev/sdX2

Now the system can be copied onto the card. First copy the u-boot onto
the region of the card before the first partition (starting from the
root directory of buildroot):

  # dd if=output/images/u-boot.imx of=/dev/sdX bs=512 seek=2

Mount the first partition /dev/sdX1, and copy the kernel and the
compiled device tree:

  # cp output/images/uImage /mnt/<BOOT-PARTITION>
  # cp output/images/imx6q-vab820.dtb /mnt/<BOOT-PARTITION>

Finally, copy the root file system onto the mounted (empty) /dev/sdX2
rootfs partition:

  # tar xf output/images/rootfs.tar -C /mnt/<ROOTFS-PARTITION>


Booting
-------

To use the on-card u-boot, you need adjust jumper J11 located just next to
the SD card slot on the VAB-820 board. The correct position for SD card
boot is jumping the two pins towards the inside of the board.

To modify the default boot parameters compiled into u-boot, you can create
a boot script with the file name `boot.scr` and place it onto the boot
partition (same directory as `uImage`).

If you want to have the login prompt on the serial debug line instead of
the console, adjust the buildroot settings as:
"System Configuration > getty options > TTY port > ttymxc1"
