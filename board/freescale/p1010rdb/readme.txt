You'll need to program the files created by buildroot into the flash.
The fast way is to tftp transfer the files via one of the network interfaces.

Alternatively you can transfer the files via serial console with an Ymodem
file transfer from your terminal program by using a "loady" command
from the u-boot prompt instead of the "tftp ..." commands stated below.
Beware that serial console file transfers are quite slow!

1. Program the DTB to NOR flash

    => tftp $loadaddr p1010rdb-pa.dtb
    => erase 0xee000000 +$filesize
    => cp.b $loadaddr 0xee000000 $filesize

2. Program the kernel to NOR flash

    => tftp $loadaddr uImage
    => erase 0xee080000 +$filesize
    => cp.b $loadaddr 0xee080000 $filesize

3. Program the root filesystem to NOR flash

    => tftp $loadaddr rootfs.jffs2
    => erase 0xee800000 0xeff5ffff
    => cp.b $loadaddr 0xee800000 $filesize

4. Booting your new system

    => setenv norboot 'setenv bootargs root=/dev/mtdblock2 rootfstype=jffs2 console=$consoledev,$baudrate;bootm 0xee080000 - 0xee000000'

    If you want to set this boot option as default:

    => setenv bootcmd 'run norboot'
    => saveenv

    ...or for a single boot:

    => run norboot

    You can login with user "root".
