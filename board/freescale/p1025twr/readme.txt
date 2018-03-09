The bootloader is no longer buildable in the latest Freescale/NXP tree or
upstream.  As such, retrieve the "Image: SDK V1.2 e500v2 Binary ISO" from
NXP downloads and follow the release notes for reflashing.

For programming the kernel and rootfs created by buildroot into the flash.
The fast way is to tftp transfer the files via one of the network interfaces.
Make sure your devkit has ipaddr and serverip defined to reach your tftp
server.

(Assuming the default u-boot env from NXP)
1. Program the DTB to NOR flash

    => setenv dtbfile p1025twr.dtb
    => run dtbflash

2. Program the kernel and rootfs to NOR flash (reusing orignal rootfs
   NOR location, as the kernel location is to small)

    => tftpboot $loadaddr uImage; protect off 0xeeb80000 +$filesize; erase 0xeeb80000 +$filesize; cp.b $loadaddr 0xeeb80000 $filesize; protect on 0xeeb80000 +$filesize; cmp.b $loadaddr 0xefa80000 $filesize

3. Booting your new system

    => bootm 0xeeb80000 - 0xefe80000

    You can login with user "root".
