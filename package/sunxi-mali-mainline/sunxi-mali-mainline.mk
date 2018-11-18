################################################################################
#
# sunxi-mali-mainline
#
################################################################################

SUNXI_MALI_MAINLINE_VERSION = cb3e8ece9b2c3a70cbeb3204cd6f30eceaa32023
SUNXI_MALI_MAINLINE_SITE = $(call github,free-electrons,mali-blobs,$(SUNXI_MALI_MAINLINE_VERSION))
SUNXI_MALI_MAINLINE_INSTALL_STAGING = YES
SUNXI_MALI_MAINLINE_PROVIDES = libegl libgles

SUNXI_MALI_MAINLINE_REV = $(call qstrip,$(BR2_PACKAGE_SUNXI_MALI_MAINLINE_REVISION))

define SUNXI_MALI_MAINLINE_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib $(STAGING_DIR)/usr/include

	cp -rf $(@D)/$(SUNXI_MALI_MAINLINE_REV)/fbdev/lib/lib_fb_dev/* \
		$(STAGING_DIR)/usr/lib/
	cp -rf $(@D)/$(SUNXI_MALI_MAINLINE_REV)/fbdev/include/* \
		$(STAGING_DIR)/usr/include/

	$(INSTALL) -D -m 0644 package/sunxi-mali-mainline/egl.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -D -m 0644 package/sunxi-mali-mainline/glesv2.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/glesv2.pc
endef

define SUNXI_MALI_MAINLINE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/$(SUNXI_MALI_MAINLINE_REV)/fbdev/lib/lib_fb_dev/* \
		$(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
