setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait ro no_console_suspend panic=10 quiet loglevel=1 ipv6.disable=1

fatload mmc 0 0x46000000 Image
fatload mmc 0 0x47000000 rootfs.cpio.uboot
fatload mmc 0 0x48000000 sun50i-h5-nanopi-neo2.dtb

booti 0x46000000 0x47000000 0x48000000
