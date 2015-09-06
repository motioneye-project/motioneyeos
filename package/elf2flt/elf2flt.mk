################################################################################
#
# elf2flt
#
################################################################################

ELF2FLT_VERSION = f859213b18a67fcfc09961267e0a1122d35186f4
ELF2FLT_SITE = http://cgit.openadk.org/cgi/cgit/elf2flt.git
ELF2FLT_SITE_METHOD = git
ELF2FLT_LICENSE = GPLv2+
ELF2FLT_LICENSE_FILES = LICENSE.TXT

HOST_ELF2FLT_DEPENDENCIES = host-binutils host-zlib

# It is not exactly a host variant, but more a cross variant, which is
# why we pass a special --target option.
HOST_ELF2FLT_CONF_OPTS = \
	--with-bfd-include-dir=$(HOST_BINUTILS_DIR)/bfd/ \
	--with-binutils-include-dir=$(HOST_BINUTILS_DIR)/include/ \
	--with-libbfd=$(HOST_BINUTILS_DIR)/bfd/libbfd.a \
	--with-libiberty=$(HOST_BINUTILS_DIR)/libiberty/libiberty.a \
	--target=$(GNU_TARGET_NAME)

HOST_ELF2FLT_LIBS = -lz

ifeq ($(BR2_GCC_ENABLE_LTO),y)
HOST_ELF2FLT_LIBS += -ldl
endif

HOST_ELF2FLT_CONF_ENV = LIBS="$(HOST_ELF2FLT_LIBS)"

$(eval $(host-autotools-package))
