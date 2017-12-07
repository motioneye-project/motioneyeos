setenv fdt_high ffffffff

setenv bootargs console=ttyS0,115200 earlyprintk root=/dev/mmcblk0p2 rootwait

fatload mmc 0 $kernel_addr_r zImage
fatload mmc 0 $fdt_addr_r sun8i-h3-orangepi-lite.dtb

bootz $kernel_addr_r - $fdt_addr_r
