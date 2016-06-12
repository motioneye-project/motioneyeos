setenv fdt_high ffffffff

setenv bootargs console=ttyS0,115200 console=tty1 earlyprintk root=/dev/mmcblk0p2 rootwait panic=10 ${extra}

fatload mmc 0 $kernel_addr_r zImage
fatload mmc 0 $fdt_addr_r sun4i-a10-pcduino.dtb

bootz $kernel_addr_r - $fdt_addr_r
