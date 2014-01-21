
******************** WARNING ********************
The compiled U-Boot binary is intended for NOR flash only!
It won't work for NAND or SPI and will brick those bootloaders!

Also don't go playing around with different U-boot versions or flash targets
unless you've got the necessary hardware and/or know-how to unbrick your kit.

2014.01 is known good for NOR on the P1010RDB-PA kit.

Freescale released a revised version of the kit with a faster processor and
some other hardware changes named P1010RDB-PB. U-Boot needs to be configured
differently for this kit hence this default config WILL NOT WORK.
This is ONLY related to U-Boot, otherwise the configuration is the same,
you can perfectly use the generated kernel and rootfs.

IF you want to build an U-Boot for the new kit just change
BR2_TARGET_UBOOT_BOARDNAME from P1010RDB-PA_NOR to P1010RDB-PB_NOR.
!!!!! THIS IS COMPLETELY UNTESTED BY BR DEVS SO YOU ARE ON YOUR OWN !!!!!
If it works we'd like to know so drop an email to the mailing list. Thanks.

If your kit doesn't mention PA nor PB in their shipping inventory then it's
the old version (PA).
******************** WARNING ********************

You'll need to program the files created by buildroot into the flash.
The fast way is to tftp transfer the files via one of the network interfaces.

Alternatively you can transfer the files via serial console with an Ymodem
file transfer from your terminal program by using a "loady" command
from the u-boot prompt instead of the "tftp ..." commands stated below.
Beware that serial console file transfers are quite slow!

Remember to set the P1010RDB switches to NOR boot if you want to use
your newly built U-Boot.

1. Program the new U-Boot binary to NOR flash (optional)
    If you don't feel confident upgrading your bootloader then don't do it,
    it's unnecessary most of the time.

    => tftp $loadaddr u-boot.bin
    => protect off 0xeff80000 +$filesize
    => erase 0xeff80000 +$filesize
    => cp.b $loadaddr 0xeff80000 $filesize

2. Program the DTB to NOR flash

    => tftp $loadaddr p1010rdb.dtb
    => erase 0xee000000 +$filesize
    => cp.b $loadaddr 0xee000000 $filesize

3. Program the kernel to NOR flash

    => tftp $loadaddr uImage
    => erase 0xee080000 +$filesize
    => cp.b $loadaddr 0xee080000 $filesize

4. Program the root filesystem to NOR flash

    => tftp $loadaddr rootfs.jffs2
    => erase 0xee800000 0xeff5ffff
    => cp.b $loadaddr 0xee800000 $filesize

5. Booting your new system

    => setenv norboot 'setenv bootargs root=/dev/mtdblock2 rootfstype=jffs2 console=$consoledev,$baudrate;bootm 0xee080000 - 0xee000000'

    If you want to set this boot option as default:

    => setenv bootcmd 'run norboot'
    => saveenv

    ...or for a single boot:

    => run norboot

    You can login with user "root".
