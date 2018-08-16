For the bootloader, NXP has stablized at SDK2.0 (final release). It is
suggested to download the prebuilt from NXP downloads and follow the
release notes for reflashing.

To program the kernel and rootfs created by buildroot into the flash. The
fast way is to tftp transfer the files via one of the network interfaces.
Make sure your devkit has ipaddr, netmask, and serverip defined to reach your
tftp server. Verify bootargs are reasonable (console=ttyS0,115200).

------------------------------------------------------------------------------

Devkit: T1040RDB

(Assuming the default u-boot env from NXP)
1. Program the DTB to NOR flash

    => tftpboot $loadaddr t1040d4rdb.dtb; protect off 0xe8800000 +$filesize; erase 0xe8800000 +$filesize; cp.b $loadaddr 0xe8800000 $filesize; protect on 0xe8800000 +$filesize; cmp.b $loadaddr 0xe8800000 $filesize

2. Program the kernel and rootfs to NOR flash

    => tftpboot $loadaddr uImage; protect off 0xe8020000 +$filesize; erase 0xe8020000 +$filesize; cp.b $loadaddr 0xe8020000 $filesize; protect on 0xe8020000 +$filesize; cmp.b $loadaddr 0xe8020000 $filesize
    => tftpboot $loadaddr rootfs.cpio.uboot; protect off 0xe9300000 +$filesize; erase 0xe9300000 +$filesize; cp.b $loadaddr 0xe9300000 $filesize; protect on 0xe9300000 +$filesize; cmp.b $loadaddr 0xe9300000 $filesize

3. Booting your new system

    => boot

    You can login with user "root".
------------------------------------------------------------------------------

Devkit: T2080 QDS or RDB

(Assuming the default u-boot env from NXP)
1. Netboot the kernel/rootfs/dtb

    => tftp 0x1000000 uImage && tftp 0x2000000 rootfs.cpio.uboot

    RDB => tftp 0x3000000 t2080rdb.dtb
     or
    QDS => tftp 0x3000000 t2080qds.dtb

2. Booting your new system

    => bootm 0x1000000 0x2000000 0x3000000

    You can login with user "root".

3. If flashing is desired, a similar approach to the T1040 can be followed
   with updated addresses for the flash layout.  Example is in the NXP default
   env.
------------------------------------------------------------------------------
