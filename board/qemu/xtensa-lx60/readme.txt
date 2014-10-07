Run the emulation with:

 qemu-system-xtensa -M lx60 -cpu dc232b -monitor null -nographic -kernel output/images/Image.elf

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.1.2
