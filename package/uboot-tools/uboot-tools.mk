################################################################################
#
# uboot-tools
#
################################################################################

UBOOT_TOOLS_VERSION = 2015.04
UBOOT_TOOLS_SOURCE = u-boot-$(UBOOT_TOOLS_VERSION).tar.bz2
UBOOT_TOOLS_SITE = ftp://ftp.denx.de/pub/u-boot
UBOOT_TOOLS_LICENSE = GPLv2+
UBOOT_TOOLS_LICENSE_FILES = Licenses/gpl-2.0.txt

define UBOOT_TOOLS_CONFIGURE_CMDS
	mkdir -p $(@D)/include/config
	touch $(@D)/include/config/auto.conf
endef

define UBOOT_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) 	\
		CROSS_COMPILE="$(TARGET_CROSS)"	\
		CFLAGS="$(TARGET_CFLAGS)"	\
		LDFLAGS="$(TARGET_LDFLAGS)"	\
		CROSS_BUILD_TOOLS=y		\
		CONFIG_FIT_SIGNATURE=$(BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE_FIT_SIGNATURE_SUPPORT) \
		tools-only
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) 	\
		CROSS_COMPILE="$(TARGET_CROSS)"	\
		CFLAGS="$(TARGET_CFLAGS)"	\
		LDFLAGS="$(TARGET_LDFLAGS)"	\
		env no-dot-config-targets=env
endef

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE),y)
define UBOOT_TOOLS_INSTALL_MKIMAGE
	$(INSTALL) -m 0755 -D $(@D)/tools/mkimage $(TARGET_DIR)/usr/bin/mkimage
endef
ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE_FIT_SIGNATURE_SUPPORT),y)
UBOOT_TOOLS_DEPENDENCIES += openssl host-pkgconf
endif # BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE_FIT_SIGNATURE_SUPPORT
endif # BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_MKENVIMAGE),y)
define UBOOT_TOOLS_INSTALL_MKENVIMAGE
	$(INSTALL) -m 0755 -D $(@D)/tools/mkenvimage $(TARGET_DIR)/usr/bin/mkenvimage
endef
endif

ifeq ($(BR2_PACKAGE_UBOOT_TOOLS_FWPRINTENV),y)
define UBOOT_TOOLS_INSTALL_FWPRINTENV
	$(INSTALL) -m 0755 -D $(@D)/tools/env/fw_printenv $(TARGET_DIR)/usr/sbin/fw_printenv
	ln -sf fw_printenv $(TARGET_DIR)/usr/sbin/fw_setenv
endef
endif

define UBOOT_TOOLS_INSTALL_TARGET_CMDS
	$(UBOOT_TOOLS_INSTALL_MKIMAGE)
	$(UBOOT_TOOLS_INSTALL_MKENVIMAGE)
	$(UBOOT_TOOLS_INSTALL_FWPRINTENV)
endef

ifeq ($(BR2_PACKAGE_HOST_UBOOT_TOOLS_FIT_SIGNATURE_SUPPORT),y)
HOST_UBOOT_TOOLS_DEPENDENCIES += host-openssl
endif

define HOST_UBOOT_TOOLS_CONFIGURE_CMDS
	mkdir -p $(@D)/include/config
	touch $(@D)/include/config/auto.conf
endef

define HOST_UBOOT_TOOLS_BUILD_CMDS
	$(MAKE1) -C $(@D) 			\
		CONFIG_FIT_SIGNATURE=$(BR2_PACKAGE_UBOOT_TOOLS_MKIMAGE_FIT_SIGNATURE_SUPPORT) \
		HOSTCC="$(HOSTCC)"		\
		HOSTCFLAGS="$(HOST_CFLAGS)"	\
		HOSTLDFLAGS="$(HOST_LDFLAGS)"	\
		tools-only
endef

define HOST_UBOOT_TOOLS_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/tools/mkimage $(HOST_DIR)/usr/bin/mkimage
	$(INSTALL) -m 0755 -D $(@D)/tools/mkenvimage $(HOST_DIR)/usr/bin/mkenvimage
endef

$(eval $(generic-package))
$(eval $(host-generic-package))

# Convenience variables for other mk files that make use of mkimage

MKIMAGE = $(HOST_DIR)/usr/bin/mkimage

# mkimage supports arm blackfin m68k microblaze mips mips64 nios2 powerpc ppc sh sparc sparc64 x86
# KERNEL_ARCH can be arm64 arc arm blackfin m68k microblaze mips nios2 powerpc sh sparc i386 x86_64 xtensa
# For arm64, arc, xtensa we'll just keep KERNEL_ARCH
# For mips64, we'll just keep mips
# For i386 and x86_64, we need to convert
ifeq ($(KERNEL_ARCH),x86_64)
MKIMAGE_ARCH = x86
else ifeq ($(KERNEL_ARCH),i386)
MKIMAGE_ARCH = x86
else
MKIMAGE_ARCH = $(KERNEL_ARCH)
endif
