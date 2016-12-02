PRU Software Support
====================

Two different packages are provided from the TI PRU software support
code base.

1. The include files and rpmsg static library for the PRU are
   installed alongside the host package for the PRU code generation
   tools package i.e. $(TI_CGT_PRU_INSTALLDIR).

2. A target package for all the examples installed to
   /usr/share/pru-software-support/. Users wanting to test a specific
   example should copy or link it to a directory where the kernel
   looks for firmware, e.g:

 # cp /usr/share/pru-software-support/am335x/PRU_gpioToggle/gen/PRU_gpioToggle.out \
   /lib/firmware/am335x-pru0-fw

To get started with the PRU, have a look at the labs [1].

[1] http://processors.wiki.ti.com/index.php/PRU_Training:_Hands-on_Labs
