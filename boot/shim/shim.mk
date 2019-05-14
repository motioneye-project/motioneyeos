################################################################################
#
# shim
#
################################################################################

SHIM_VERSION = 15
SHIM_SITE = $(call github,rhboot,shim,$(SHIM_VERSION))
SHIM_LICENSE = BSD-2-Clause
SHIM_LICENSE_FILES = COPYRIGHT
SHIM_DEPENDENCIES = gnu-efi
SHIM_INSTALL_TARGET = NO
SHIM_INSTALL_IMAGES = YES

SHIM_MAKE_OPTS = \
	ARCH="$(GNU_EFI_PLATFORM)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	DASHJ="-j$(PARALLEL_JOBS)" \
	EFI_INCLUDE="$(STAGING_DIR)/usr/include/efi" \
	EFI_PATH="$(STAGING_DIR)/usr/lib" \
	LIBDIR="$(STAGING_DIR)/usr/lib"

define SHIM_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) $(SHIM_MAKE_OPTS)
endef

define SHIM_INSTALL_IMAGES_CMDS
	$(INSTALL) -m 0755 -t $(BINARIES_DIR) $(@D)/*.efi
endef

$(eval $(generic-package))
