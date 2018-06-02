Run the emulation with:

 qemu-system-ppc64 -M ppce500 -cpu e5500 -m 256 -kernel output/images/uImage -drive file=output/images/rootfs.ext2,if=virtio,format=raw -append "console=ttyS0 root=/dev/vda" -serial mon:stdio -nographic

The login prompt will appear in the terminal that started Qemu.

Tested with QEMU 2.12.0
