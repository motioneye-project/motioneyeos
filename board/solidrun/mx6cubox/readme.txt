Solidrun's MX6 Cubox/Hummingboard

https://www.solid-run.com/freescale-imx6-family/hummingboard/

https://www.solid-run.com/freescale-imx6-family/cubox-i/

To build a minimal support for these boards:

    $ make mx6cubox_defconfig
    $ make

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on an SD card:

dd if=output/images/sdcard.img of=/dev/<your-microsd-device>

For details about the medium image layout, see the definition in
board/solidrun/mx6cubox/genimage.cfg.
