Udoo MX6Q/DL board

For information about MX6 Udoo boards:
http://www.udoo.org/

To build a minimal support for these boards:

    $ make mx6udoo_defconfig
    $ make

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on a micro SD card:

dd if=output/images/sdcard.img of=/dev/<your-microsd-device>

For details about the medium image layout, see the definition in
board/udoo/mx6qdl/genimage.cfg.
