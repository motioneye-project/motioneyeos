Run the emulation with:

 qemu-system-ppc64 -M pseries -cpu POWER7 -m 256 -kernel output/images/vmlinux -append 'console=hvc0 root=/dev/sda' -drive file=output/images/rootfs.ext2,if=scsi,index=0 -serial stdio -display curses

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.1.2
