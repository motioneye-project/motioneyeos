Run the emulation with:

 qemu-system-xtensa -M lx60 -cpu dc233c -monitor null -nographic -kernel output/images/Image.elf

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.6.0
Known to fail with 2.5.0
