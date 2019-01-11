################################################################################
#
# gnu-efi
#
################################################################################

GNU_EFI_VERSION = 3.0.9
GNU_EFI_SOURCE = gnu-efi-$(GNU_EFI_VERSION).tar.bz2
GNU_EFI_SITE = http://downloads.sourceforge.net/project/gnu-efi
GNU_EFI_INSTALL_STAGING = YES
GNU_EFI_LICENSE = BSD-3-Clause and/or GPL-2.0+ (gnuefi), BSD-3-Clause (efilib)
GNU_EFI_LICENSE_FILES = README.efilib

# gnu-efi is a set of library and header files used to build
# standalone EFI applications such as bootloaders. There is no point
# in installing these libraries to the target.
GNU_EFI_INSTALL_TARGET = NO

ifeq ($(BR2_i386),y)
GNU_EFI_PLATFORM = ia32
else ifeq ($(BR2_x86_64),y)
GNU_EFI_PLATFORM = x86_64
else ifeq ($(BR2_arm)$(BR2_armeb),y)
GNU_EFI_PLATFORM = arm
else ifeq ($(BR2_aarch64)$(BR2_aarch64_be),y)
GNU_EFI_PLATFORM = aarch64
endif

GNU_EFI_MAKE_OPTS = \
	ARCH=$(GNU_EFI_PLATFORM) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	PREFIX=/usr

define GNU_EFI_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(GNU_EFI_MAKE_OPTS)
endef

define GNU_EFI_INSTALL_STAGING_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(GNU_EFI_MAKE_OPTS) \
		INSTALLROOT=$(STAGING_DIR) install
endef

$(eval $(generic-package))
