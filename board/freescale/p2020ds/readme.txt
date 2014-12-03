You'll need to program the files created by buildroot into the flash.
The fast way is to tftp transfer the files via one of the network interfaces.

Alternatively you can transfer the files via serial console with an Ymodem
file transfer from your terminal program by using a "loady" command
from the u-boot prompt instead of the "tftp ..." commands stated below.
Beware that serial console file transfers are quite slow!

1. Program the DTB to NOR flash

   => tftp ${loadaddr} p2020ds.dtb
   => erase 0xeff00000 0xeff7ffff
   => cp.b ${loadaddr} 0xeff00000 ${filesize}

2. Program the kernel to NOR flash

   => tftp ${loadaddr} uImage
   => erase 0xec000000 0xec3fffff
   => cp.b ${loadaddr} 0xec000000 ${filesize}

3. Program the root filesystem to NOR flash

   => tftp ${loadaddr} rootfs.jffs2
   => erase 0xec400000 0xeeffffff
   => cp.b ${loadaddr} 0xec400000 ${filesize}

4. Booting your new system

   => setenv jffs2boot 'setenv bootargs root=/dev/mtdblock4 rootfstype=jffs2 rw console=ttyS0,115200;bootm ec000000 - eff00000'

   If you want to set this boot option as default:

   => setenv bootcmd 'run jffs2boot'
   => saveenv

   ...or for a single boot:

   => run jffs2boot

   You can login with user "root".
