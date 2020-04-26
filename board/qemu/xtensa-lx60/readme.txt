Run the emulation with:

 qemu-system-xtensa -M lx60 -cpu dc233c -monitor null -nographic -kernel output/images/Image.elf # qemu_xtensa_lx60_defconfig

 qemu-system-xtensa -M lx60 -cpu dc233c -monitor null -nographic -kernel output/images/Image.elf # qemu_xtensa_lx60_nommu_defconfig

The login prompt will appear in the terminal that started Qemu.
