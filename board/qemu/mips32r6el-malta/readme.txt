Run the emulation with:

qemu-system-mipsel -M malta -cpu mips32r6-generic -kernel output/images/vmlinux -drive file=output/images/rootfs.ext2,format=raw -append "root=/dev/hda" -net nic,model=pcnet -net user -nographic

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.12.0
