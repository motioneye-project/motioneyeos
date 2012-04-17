# Required includes for the external toolchain backend

include toolchain/helpers.mk
include toolchain/elf2flt/elf2flt.mk
include toolchain/gcc/gcc-uclibc-4.x.mk
include toolchain/gdb/gdb.mk
include toolchain/kernel-headers/kernel-headers.mk
include toolchain/toolchain-external/ext-tool.mk
include toolchain/uClibc/uclibc.mk
