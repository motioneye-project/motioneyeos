setenv kernel_addr 0x42000000
setenv ramdisk_addr 0x43000000
setenv fdt_addr 0x44000000 
setenv env_addr 0x45000000

fatload mmc 0 ${kernel_addr} zImage
fatload mmc 0 ${ramdisk_addr} uInitrd
fatload mmc 0 ${fdt_addr} sun8i-h3-nanopi-r1.dtb
fatload mmc 0 ${env_addr} uEnv.txt
env import -t ${env_addr} ${filesize}

fdt addr ${fdt_addr}
fdt set mmc0 boot_device <1>

setenv bootargs console=ttyS0,115200 earlyprintk root=${disk_dev}p2 rootfstype=ext4 rootwait ro rootflags=noload panic=10 quiet loglevel=1

if test "${initramfs_enabled}" = "1"; then
    bootz ${kernel_addr} ${ramdisk_addr} ${fdt_addr}
else
    bootz ${kernel_addr} - ${fdt_addr}
fi
