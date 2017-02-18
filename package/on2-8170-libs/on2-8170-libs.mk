################################################################################
#
# on2-8170-libs
#
################################################################################

ON2_8170_LIBS_VERSION = 1.0
ON2_8170_LIBS_SITE = ftp://ftp.linux4sam.org/pub/demo/linux4sam_1.9/codec

ON2_8170_LICENSE = PROPRIETARY
# No license file is included in the archive

ON2_8170_LIBS_INSTALL_STAGING = YES

define ON2_8170_LIBS_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/lib $(STAGING_DIR)/usr/include
	cp -dpf $(@D)/*.a $(@D)/*.so $(STAGING_DIR)/usr/lib
	cp -dpf $(@D)/*.h $(STAGING_DIR)/usr/include
endef

define ON2_8170_LIBS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib
	cp -dpf $(@D)/*.so $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
