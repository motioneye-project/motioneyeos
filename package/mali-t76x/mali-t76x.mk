################################################################################
#
# mali-t76x
#
################################################################################

MALI_T76X_VERSION = r5p0-06rel0
MALI_T76X_SOURCE = mali-t76x_$(MALI_T76X_VERSION)_linux_1+fbdev.tar.gz
MALI_T76X_SITE = http://malideveloper.arm.com/downloads/drivers/binary/$(MALI_T76X_VERSION)

MALI_T76X_INSTALL_STAGING = YES
MALI_T76X_PROVIDES = libegl libgles

define MALI_T76X_INSTALL_STAGING_CMDS
	$(INSTALL) -m 755 $(@D)/*.so $(STAGING_DIR)/usr/lib/

	$(INSTALL) -D -m 0644 package/mali-t76x/egl.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -D -m 0644 package/mali-t76x/glesv2.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/glesv2.pc
endef

define MALI_T76X_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/*.so $(TARGET_DIR)/usr/lib/
endef

$(eval $(generic-package))
