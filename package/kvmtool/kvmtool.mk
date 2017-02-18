################################################################################
#
# kvmtool
#
################################################################################

KVMTOOL_VERSION = 372f583d359a5bdcbbe7268809c8d1dc179c64d2
KVMTOOL_SITE = $(BR2_KERNEL_MIRROR)/scm/linux/kernel/git/will/kvmtool.git
KVMTOOL_SITE_METHOD = git
KVMTOOL_DEPENDENCIES = \
	$(if $(BR2_PACKAGE_BINUTILS),binutils) \
	$(if $(BR2_PACKAGE_DTC),dtc) \
	$(if $(BR2_PACKAGE_LIBAIO),libaio) \
	$(if $(BR2_PACKAGE_LIBGTK3),libgtk3) \
	$(if $(BR2_PACKAGE_LIBVNCSERVER),libvncserver) \
	$(if $(BR2_PACKAGE_SDL),sdl) \
	$(if $(BR2_PACKAGE_ZLIB),zlib)
KVMTOOL_LICENSE = GPLv2
KVMTOOL_LICENSE_FILES = COPYING

# This is required to convert a static binary (init helper) back into
# object-file format, and in multilib toolchains like CS 2012.09 for x86
# the default is i386, hence when building for x86_64 things break since
# LD doesn't autodetect the input file format.
# GCC-as-linker can't accomplish this feat easily either since it's mixing
# static content (guest_init.o) with dynamic one (lkvm) making
# a relocatable output file.
# The purpose of this trick is to embed the init helper into the main
# binary to help users in guest system startup, which would otherwise
# require more complex guest images.
# This needs revisiting if/when X32 ABI support is added.
#
# If more packages need this (unlikely) an ld wrapper might be a better
# solution, using gcc -dumpspecs information.
KVMTOOL_EXTRA_LDFLAGS = \
	$(if $(BR2_x86_64),-m elf_x86_64)

# Disable -Werror, otherwise musl is not happy
KVMTOOL_MAKE_OPTS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	LDFLAGS="$(TARGET_LDFLAGS) $(KVMTOOL_EXTRA_LDFLAGS)" \
	WERROR=0

define KVMTOOL_BUILD_CMDS
	$(TARGET_MAKE_ENV) ARCH=$(KERNEL_ARCH) $(MAKE) -C $(@D) $(KVMTOOL_MAKE_OPTS)
endef

define KVMTOOL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) ARCH=$(KERNEL_ARCH) $(MAKE) -C $(@D) \
		$(KVMTOOL_MAKE_OPTS) install DESTDIR=$(TARGET_DIR) prefix=/usr
endef

$(eval $(generic-package))
