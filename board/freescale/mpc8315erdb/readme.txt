You'll need to program the files created by buildroot into the flash.
The fast way is to tftp transfer the files via one of the network interfaces.

Alternatively you can transfer the files via serial console with an Ymodem
file transfer from your terminal program by using a "loady" command
from the u-boot prompt instead of the "tftp ..." commands stated below.
Beware that serial console file transfers are quite slow!

1. Program the kernel to NAND flash

    => tftp $loadaddr uImage
    => nand erase 0x100000 0x1e0000
    => nand write $loadaddr 0x100000 0x1e0000

2. Program the DTB to NAND flash

    => tftp $loadaddr mpc8315erdb.dtb
    => nand erase 0x2e0000 0x20000
    => nand write $loadaddr 0x2e0000 0x20000

3. Program the root filesystem to NAND flash

    => tftp $loadaddr rootfs.jffs2
    => nand erase 0x400000 0x1c00000
    => nand write $loadaddr 0x400000 $filesize

4. Booting your new system

    => setenv nandboot 'setenv bootargs root=/dev/mtdblock3 rootfstype=jffs2 console=$consoledev,$baudrate;nand read $fdtaddr 0x2e0000 0x20000;nand read $loadaddr 0x100000 0x1e0000;bootm $loadaddr - $fdtaddr'

    If you want to set this boot option as default:

    => setenv bootcmd 'run nandboot'
    => saveenv

    ...or for a single boot:

    => run nandboot

    You can login with user "root".
