Minimal board support for the Wandboard

Wandboard's homepage is here: http://www.wandboard.org/

This config is only tested with the dual core wandboard.

Installing:

You need a micro SD card and a slot/adapter for your development machine.

Partition the SD card leaving at least 1 MB in front of the first partition.

Partition layout (example):

Disk /dev/sdi: 3965 MB, 3965190144 bytes
255 heads, 63 sectors/track, 482 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x77b47445

   Device Boot      Start         End      Blocks   Id  System
/dev/sdi1               2         482     3863632+  83  Linux

Copy u-boot and its environment to the SD card:
sudo dd if=output/images/u-boot.imx bs=512 seek=2 of=/dev/sd<x>
sudo dd if=output/images/uboot-env.bin bs=512 seek=768 of=/dev/sd<x>

Copy the root filesystem:
sudo dd if=output/images/rootfs.ext2 of=/dev/sd<x>1

Alternative commands to copy root filesystem:
sudo mkfs.ext4 /dev/sd<x>1
sudo mount /dev/sd<x>1 /mnt
sudo tar xf output/images/rootfs.tar -C /mnt
sudo umount /mnt

