Wandboard

http://www.wandboard.org

To build a minimal support for this board:

    $ make wandboard_defconfig
    $ make

Buildroot prepares a bootable "sdcard.img" image in the output/images/
directory, ready to be dumped on an SD card.

For details about the medium image layout, see the definition in
board/wandboard/genimage.cfg.
