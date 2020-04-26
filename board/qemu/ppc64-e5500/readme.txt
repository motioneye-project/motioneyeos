Run the emulation with:

 qemu-system-ppc64 -M ppce500 -cpu e5500 -m 256 -kernel output/images/uImage -drive file=output/images/rootfs.ext2,if=virtio,format=raw -append "console=ttyS0 rootwait root=/dev/vda" -serial mon:stdio -nographic # qemu_ppc64_e5500_defconfig

The login prompt will appear in the terminal that started Qemu.
