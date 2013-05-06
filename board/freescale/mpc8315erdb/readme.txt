
******************** WARNING ********************
The compiled U-Boot binary is intended for NAND flash only!
It won't work for NOR and will brick that bootloader!

Also don't go playing around with different U-boot versions or flash targets
unless you've got the necessary hardware and/or know-how to unbrick your kit.

2013.04 is known good for NAND.
******************** WARNING ********************

You'll need to program the files created by buildroot into the flash.
The fast way is to tftp transfer the files via one of the network interfaces.

Alternatively you can transfer the files via serial console with an Ymodem
file transfer from your terminal program by using a "loady" command
from the u-boot prompt instead of the "tftp ..." commands stated below.
Beware that serial console file transfers are quite slow!

Remember to set the MPC8315ERDB switches to NAND boot if you want to use
your newly built U-Boot.

1. Program the new U-Boot binary to NAND flash (optional)
    If you don't feel confident upgrading your bootloader then don't do it,
    it's unnecessary most of the time.

    => tftp $loadaddr u-boot-nand.bin
    => nand erase 0 0x80000
    => nand write $loadaddr 0 0x80000 $filesize

2. Program the kernel to NAND flash

    => tftp $loadaddr uImage
    => nand erase 0x100000 0x1e0000
    => nand write $loadaddr 0x100000 0x1e0000

3. Program the DTB to NAND flash

    => tftp $loadaddr mpc8315erdb.dtb
    => nand erase 0x2e0000 0x20000
    => nand write $loadaddr 0x2e0000 0x20000

4. Program the root filesystem to NAND flash

    => tftp $loadaddr rootfs.jffs2
    => nand erase 0x400000 0x1c00000
    => nand write $loadaddr 0x400000 $filesize

5. Booting your new system

    => setenv nandboot 'setenv bootargs root=/dev/mtdblock3 rootfstype=jffs2 console=$consoledev,$baudrate;nand read $fdtaddr 0x2e0000 0x20000;nand read $loadaddr 0x100000 0x1e0000;bootm $loadaddr - $fdtaddr'

    If you want to set this boot option as default:

    => setenv bootcmd 'run nandboot'
    => saveenv

    ...or for a single boot:

    => run nandboot

    You can login with user "root".
