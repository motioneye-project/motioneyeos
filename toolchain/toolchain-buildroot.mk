# Triggerring the build of the host-gcc-final will automaticaly do the
# build of binutils, uClibc, kernel headers and all the intermediate
# gcc steps.

toolchain-buildroot: host-gcc-final
