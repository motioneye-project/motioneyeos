Run the emulation with:

  qemu-system-ppc -nographic -vga none -M mac99 -cpu g4 -m 1G -kernel output/images/vmlinux -drive file=output/images/rootfs.ext2,format=raw -net nic,model=sungem -net user -append "root=/dev/sda" # qemu_ppc_mac99_defconfig
