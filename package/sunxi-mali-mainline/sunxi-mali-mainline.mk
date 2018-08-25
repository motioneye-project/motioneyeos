################################################################################
#
# sunxi-mali-mainline
#
################################################################################

SUNXI_MALI_MAINLINE_VERSION = d691cb93884ca8ac67860502117bbec283dc19aa
SUNXI_MALI_MAINLINE_SITE = $(call github,bootlin,mali-blobs,$(SUNXI_MALI_MAINLINE_VERSION))
SUNXI_MALI_MAINLINE_INSTALL_STAGING = YES
SUNXI_MALI_MAINLINE_PROVIDES = libegl libgles
SUNXI_MALI_MAINLINE_LICENSE = Allwinner End User Licence Agreement
SUNXI_MALI_MAINLINE_EULA_ORIGINAL = EULA\ for\ Mali\ 400MP\ _AW.pdf
SUNXI_MALI_MAINLINE_EULA_NO_SPACES = EULA_for_Mali_400MP_AW.pdf
SUNXI_MALI_MAINLINE_LICENSE_FILES = $(SUNXI_MALI_MAINLINE_EULA_NO_SPACES)

SUNXI_MALI_MAINLINE_REV = $(call qstrip,$(BR2_PACKAGE_SUNXI_MALI_MAINLINE_REVISION))

ifeq ($(BR2_arm),y)
SUNXI_MALI_MAINLINE_ARCH=arm
else ifeq ($(BR2_aarch64),y)
SUNXI_MALI_MAINLINE_ARCH=arm64
endif

define SUNXI_MALI_MAINLINE_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib $(STAGING_DIR)/usr/include

	cp -rf $(@D)/$(SUNXI_MALI_MAINLINE_REV)/$(SUNXI_MALI_MAINLINE_ARCH)/fbdev/*.so* \
		$(STAGING_DIR)/usr/lib/
	cp -rf $(@D)/include/fbdev/* $(STAGING_DIR)/usr/include/

	$(INSTALL) -D -m 0644 package/sunxi-mali-mainline/egl.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -D -m 0644 package/sunxi-mali-mainline/glesv2.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/glesv2.pc
endef

define SUNXI_MALI_MAINLINE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -rf $(@D)/$(SUNXI_MALI_MAINLINE_REV)/$(SUNXI_MALI_MAINLINE_ARCH)/fbdev/*.so* \
		$(TARGET_DIR)/usr/lib/
endef

define SUNXI_MALI_MAINLINE_FIXUP_LICENSE_FILE
	mv $(@D)/$(SUNXI_MALI_MAINLINE_EULA_ORIGINAL) $(@D)/$(SUNXI_MALI_MAINLINE_EULA_NO_SPACES)
endef

SUNXI_MALI_MAINLINE_POST_PATCH_HOOKS += SUNXI_MALI_MAINLINE_FIXUP_LICENSE_FILE

$(eval $(generic-package))
