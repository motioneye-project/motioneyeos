################################################################################
#
# elf2flt
#
################################################################################

ELF2FLT_VERSION = 7e33f28df198c46764021ed14408bd262751e148
ELF2FLT_SITE = $(call github,uclinux-dev,elf2flt,$(ELF2FLT_VERSION))
ELF2FLT_LICENSE = GPL-2.0+
ELF2FLT_LICENSE_FILES = LICENSE.TXT

HOST_ELF2FLT_DEPENDENCIES = host-binutils host-zlib

# It is not exactly a host variant, but more a cross variant, which is
# why we pass a special --target option.
HOST_ELF2FLT_CONF_OPTS = \
	--with-bfd-include-dir=$(HOST_BINUTILS_DIR)/bfd/ \
	--with-binutils-include-dir=$(HOST_BINUTILS_DIR)/include/ \
	--with-libbfd=$(HOST_BINUTILS_DIR)/bfd/libbfd.a \
	--with-libiberty=$(HOST_BINUTILS_DIR)/libiberty/libiberty.a \
	--target=$(GNU_TARGET_NAME) \
	--disable-werror

HOST_ELF2FLT_LIBS = -lz

ifeq ($(BR2_GCC_ENABLE_LTO),y)
HOST_ELF2FLT_LIBS += -ldl
endif

HOST_ELF2FLT_CONF_ENV = LIBS="$(HOST_ELF2FLT_LIBS)"

# Hardlinks between binaries in different directories cause a problem
# with rpath fixup, so we de-hardlink those binaries, and replace them
# with copies instead. Note that elf2flt will rename ld to ld.real
# before installing its own ld, but we already took care of the
# original ld from binutils so that it is already de-hardlinked. So
# ld is now the one from elf2flt, and we want to de-hardlinke it.
ELF2FLT_TOOLS = elf2flt flthdr ld
define HOST_ELF2FLT_FIXUP_HARDLINKS
	$(foreach tool,$(ELF2FLT_TOOLS),\
		rm -f $(HOST_DIR)/$(GNU_TARGET_NAME)/bin/$(tool) && \
		cp -a $(HOST_DIR)/bin/$(GNU_TARGET_NAME)-$(tool) \
			$(HOST_DIR)/$(GNU_TARGET_NAME)/bin/$(tool)
	)
endef
HOST_ELF2FLT_POST_INSTALL_HOOKS += HOST_ELF2FLT_FIXUP_HARDLINKS

$(eval $(host-autotools-package))
