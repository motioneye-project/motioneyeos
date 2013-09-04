################################################################################
#
# elf2flt
#
################################################################################

ELF2FLT_VERSION = 20130904
ELF2FLT_SITE = cvs://cvs.uclinux.org:/var/cvs
ELF2FLT_SITE_METHOD = cvs
ELF2FLT_LICENSE = GPLv2+
ELF2FLT_LICENSE_FILES = LICENSE.TXT

HOST_ELF2FLT_DEPENDENCIES = host-binutils host-zlib

# It is not exactly a host variant, but more a cross variant, which is
# why we pass a special --target option.
HOST_ELF2FLT_CONF_OPT = \
	--with-bfd-include-dir=$(HOST_BINUTILS_DIR)/bfd/ \
	--with-binutils-include-dir=$(HOST_BINUTILS_DIR)/include/ \
	--with-libbfd=$(HOST_BINUTILS_DIR)/bfd/libbfd.a \
	--with-libiberty=$(HOST_BINUTILS_DIR)/libiberty/libiberty.a \
	--target=$(GNU_TARGET_NAME)

HOST_ELF2FLT_CONF_ENV = LIBS=-lz

$(eval $(host-autotools-package))
