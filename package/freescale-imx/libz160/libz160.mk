################################################################################
#
# libz160
#
################################################################################

LIBZ160_VERSION = 11.09.01
LIBZ160_SOURCE = libz160-bin-$(LIBZ160_VERSION).bin
LIBZ160_SITE = $(FREESCALE_IMX_SITE)
LIBZ160_INSTALL_STAGING = YES

# See freescale-imx
LIBZ160_LICENSE = Freescale Semiconductor Software License Agreement
LIBZ160_LICENSE_FILES = EULA
LIBZ160_REDISTRIBUTE = NO

define LIBZ160_EXTRACT_CMDS
	$(call FREESCALE_IMX_EXTRACT_HELPER,$(LIBZ160_DL_DIR)/$(LIBZ160_SOURCE))
endef

define LIBZ160_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 755 $(@D)/usr/lib/libz160.so $(STAGING_DIR)/usr/lib/libz160.so
	$(INSTALL) -D -m 644 $(@D)/usr/include/z160.h $(STAGING_DIR)/usr/include/z160.h
endef

define LIBZ160_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/usr/lib/libz160.so $(TARGET_DIR)/usr/lib/libz160.so
endef

$(eval $(generic-package))
