This little documentation explains how to build a kernel and a rootfs
for qemu with sh4 architecture.

1) Select qemu sh4 configuration and compile it :

make sh4_defconfig
make all

2) Run qemu-system-sh4 with the kernel and rootfs previously generated

It's recommended to use a git release for qemu (the current stable
version has framebuffer display issues). If you want to avoid building
all target, you can use this option on qemu configure :
--target-list=sh4-softmmu

The command is :
qemu-system-sh4 -M r2d -kernel output/images/zImage -drive file=output/images/rootfs.ext2,if=ide,format=raw -append root=/dev/sda console=ttySC1,115200 noiotrap
