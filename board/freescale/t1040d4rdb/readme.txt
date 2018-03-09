For the bootloader, NXP has stablized at SDK2.0 (final release). It is
suggested to download the prebuilt from NXP downloads and follow the
release notes for reflashing.

To program the kernel and rootfs created by buildroot into the flash. The
fast way is to tftp transfer the files via one of the network interfaces.
Make sure your devkit has ipaddr and serverip defined to reach your tftp
server.

(Assuming the default u-boot env from NXP)
1. Program the DTB to NOR flash

    => tftpboot $loadaddr t1040d4rdb.dtb; protect off 0xe8800000 +$filesize; erase 0xe8800000 +$filesize; cp.b $loadaddr 0xe8800000 $filesize; protect on 0xe8800000 +$filesize; cmp.b $loadaddr 0xe8800000 $filesize

2. Program the kernel and rootfs to NOR flash

    => tftpboot $loadaddr uImage; protect off 0xe8020000 +$filesize; erase 0xe8020000 +$filesize; cp.b $loadaddr 0xe8020000 $filesize; protect on 0xe8020000 +$filesize; cmp.b $loadaddr 0xe8020000 $filesize
    => tftpboot $loadaddr rootfs.cpio.uboot; protect off 0xe9300000 +$filesize; erase 0xe9300000 +$filesize; cp.b $loadaddr 0xe9300000 $filesize; protect on 0xe9300000 +$filesize; cmp.b $loadaddr 0xe9300000 $filesize

3. Booting your new system

    => boot

    You can login with user "root".
