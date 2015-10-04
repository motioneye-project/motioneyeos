setenv bootargs console=tty1 root=/dev/mmcblk0p2 rootwait panic=10 earlyprintk ${extra}
fatload mmc 0 0x49000000 sun7i-a20-bananapi.dtb
fatload mmc 0 0x46000000 uImage
setenv fdt_high ffffffff
setenv video-mode sunxi:1024x768-24@60,monitor=hdmi,hpd=1,edid=1
bootm 0x46000000 - 0x49000000

