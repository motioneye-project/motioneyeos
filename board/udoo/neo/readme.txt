MX6X Udoo Neo board

http://www.udoo.org/udoo-neo/

To build a minimal support for these boards:

    $ make mx6sx_udoo_neo_defconfig
    $ make

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on an SD card:

dd if=output/images/sdcard.img of=/dev/<your-microsd-device>

For details about the medium image layout, see the definition in
board/udoo/neo/genimage.cfg.
