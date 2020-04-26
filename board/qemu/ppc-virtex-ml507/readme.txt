Run the emulation with:

 qemu-system-ppc -M virtex-ml507 -kernel output/images/vmlinux -m 256 -nographic -append "console=ttyS0" -dtb output/images/virtex440-ml507.dtb # qemu_ppc_virtex_ml507_defconfig

The login prompt will appear in the terminal that started Qemu.
