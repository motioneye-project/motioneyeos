Board qemu_arm_vexpress_tz builds a QEMU ARMv7-A target system with
OP-TEE running in the TrustZone secure world and a Linux based
OS running in the non-secure world. The board configuration enables
builds of the QEMU host ARM target emulator.

  make qemu_arm_vexpress_tz_defconfig
  make

The BIOS used in the QEMU host is the ARM Trusted Firmware-A (TF-A). TF-A
uses QEMU semihosting file access to access boot image files. The
QEMU platform is quite specific for that in TF-A and one needs to
run the emulation from the image directory for TF-A to boot the
secure and non-secure worlds.

  cd output/images && ../host/bin/qemu-system-arm \
	-machine virt -machine secure=on -cpu cortex-a15 \
	-smp 1 -s -m 1024 -d unimp \
	-serial stdio \
	-netdev user,id=vmnic -device virtio-net-device,netdev=vmnic \
	-semihosting-config enable,target=native \
	-bios bl1.bin

The boot stage traces (if any) followed by the login prompt will appear
in the terminal that started QEMU.

If you want to emulate more cores, use "-smp {1|2|3|4}" to select the
number of cores.

Note: "-netdev user,id=vmnic -device virtio-net-device,netdev=vmnic"
brings network support that is used i.e. in OP-TEE regression tests.


-- Boot Details --

TF-A is used as QEMU BIOS. Its BL1 image boots and load its BL2 image. In turn,
this image loads the OP-TEE secure world (ARMv7-A BL32 stage) and the U-boot as
non-secure bootloader (BL33 stage).

QEMU natively hosts and loads in RAM the QEMU ARM target device tree. OP-TEE
reads and modifies its content according to OP-TEE configuration.

Enable TF-A traces from LOG_LEVEL (I.e LOG_LEVEL=40) from
BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES.


-- OP-TEE Traces --

Secure boot stages and/or secure runtime services may use a serial link for
their traces.

The ARM Trusted Firmware outputs its traces on the QEMU standard (first)
serial interface.

The OP-TEE OS uses the QEMU second serial interface.

To get the OP-TEE OS traces, append a second -serial argument after
-serial stdio in the QEMU command line. I.e, the following enables 2 serial
consoles over telnet connections:

  cd output/images && ../host/bin/qemu-system-arm \
	-machine virt -machine secure=on -cpu cortex-a15 \
	-smp 1 -s -m 1024 -d unimp \
	-serial telnet:127.0.0.1:1235,server \
	-serial telnet:127.0.0.1:1236,server \
	-netdev user,id=vmnic -device virtio-net-device,netdev=vmnic \
	-semihosting-config enable,target=native \
	-bios bl1.bin

QEMU is now waiting for the telnet connection. From another shell, open a
telnet connection on the port for the U-boot and Linux consoles:

  telnet 127.0.0.1 1235

and again for the secure console

  telnet 127.0.0.1 1236


-- Using gdb --

One can debug the OP-TEE secure world using GDB through the QEMU host.
To do so, simply run the qemu-system-arm emulation, then run a GDB client
and connect the QEMU internal GDB server.

The example below assumes we run QEMU and the GDB client from the same
host computer. We use option -S of qemu-system-arm to make QEMU
waiting for the GDB continue instruction before booting the images.

From a first shell:
  cd output/images && ../host/bin/qemu-system-arm \
	-machine virt -machine secure=on -cpu cortex-a15 \
	-smp 1 -s -m 1024 -d unimp \
	-serial stdio \
	-netdev user,id=vmnic -device virtio-net-device,netdev=vmnic \
	-semihosting-config enable,target=native \
	-bios bl1.bin \
	-S

From a second shell:
  ./output/host/bin/arm-linux-gdb
  GNU gdb (GNU Toolchain for the A-profile Architecture 8.2-2018-08 (arm-rel-8.23)) 8.1.1.20180704-git
  Copyright (C) 2018 Free Software Foundation, Inc.
  ...
  For help, type "help".
  Type "apropos word" to search for commands related to "word".
  (gdb)

From this GDB console, connect to the target, load the OP-TEE core symbols,
set a breakpoint to its entry point (__text_start) and start emulation:

  (gdb) target remote 127.0.0.1:1234
  (gdb) symbol-file ./output/build/optee-os-<reference>/out/arm/core/tee.elf
  (gdb) hbreak __text_start
  Hardware assisted breakpoint 1 at 0xe100000: file core/arch/arm/kernel/generic_entry_a32.S, line 246.
  (gdb) cont
  Continuing.

  Thread 1 hit Breakpoint 1, _start () at core/arch/arm/kernel/generic_entry_a32.S:246
  246		bootargs_entry
  (gdb)


Emulation has started, TF-A has loaded OP-TEE and U-boot images in memory and
has booted OP-TEE. Emulation stopped at OP-TEE core entry.

Note: QEMU hosts a GDB service listening to TCP port 1234, as set through
qemu-system-arm command line option -s.

Note: To build the GDB server, the following extra options have to be added to
the Buildroot configuration:

    BR2_ENABLE_DEBUG=y
    BR2_PACKAGE_GDB=y
    BR2_PACKAGE_HOST_GDB=y
    BR2_TOOLCHAIN_BUILDROOT_CXX=y
    BR2_TOOLCHAIN_BUILDROOT_GLIBC=y
