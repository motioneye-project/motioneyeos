setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk1p2 rootwait ro no_console_suspend panic=10 quiet loglevel=1

fatload mmc 0 0x46000000 zImage
fatload mmc 0 0x47000000 rootfs.cpio.uboot
fatload mmc 0 0x48000000 sun8i-h3-nanopi-neo.dtb

bootz 0x46000000 0x47000000 0x48000000
