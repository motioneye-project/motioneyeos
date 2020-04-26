Run the emulation with:

 qemu-system-ppc -M mpc8544ds -kernel output/images/vmlinux -serial stdio -net nic,model=e1000 -net user # qemu_ppc_mpc8544ds_defconfig

The login prompt will appear in the terminal that started Qemu.
