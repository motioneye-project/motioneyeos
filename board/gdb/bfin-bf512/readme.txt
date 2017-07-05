Run the simulation with GDB for FDPIC:

 ./output/host/bin/bfin-buildroot-linux-uclibc-run --env operating --model bf512 output/images/vmlinux

Run the simulation with GDB for FLAT:

 ./output/host/bin/bfin-buildroot-uclinux-uclibc-run --env operating --model bf512 output/images/vmlinux

The login prompt will appear in the terminal that started GDB.

Tested with GDB 7.9
