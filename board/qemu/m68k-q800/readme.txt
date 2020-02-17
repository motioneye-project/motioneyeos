Run the emulation with:

 qemu-system-m68k -M q800 -kernel output/images/vmlinux -nographic -drive file=output/images/rootfs.ext2,format=raw -append "rootwait root=/dev/sda console=ttyS0" # qemu_m68k_q800_defconfig

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.11.0 from https://github.com/vivier/qemu-m68k
You need following branch: q800-v2.11.0
