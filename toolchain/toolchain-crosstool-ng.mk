# Required includes for the external toolchain backend

# Explicit ordering:
include toolchain/helpers.mk
include toolchain/elf2flt/elf2flt.mk
include toolchain/gcc/gcc-uclibc-4.x.mk
include toolchain/gdb/gdb.mk
include toolchain/toolchain-crosstool-ng/crosstool-ng.mk
include toolchain/uClibc/uclibc.mk
