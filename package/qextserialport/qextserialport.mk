#############################################################
#
# qextserialport
#
#############################################################

QEXTSERIALPORT_VERSION     = ef4af2a2ee3f
QEXTSERIALPORT_SITE        = https://qextserialport.googlecode.com/hg/
QEXTSERIALPORT_SITE_METHOD = hg

QEXTSERIALPORT_DEPENDENCIES = qt

QEXTSERIALPORT_INSTALL_STAGING = YES

define QEXTSERIALPORT_CONFIGURE_CMDS
	(cd $(@D); $(QT_QMAKE))
endef

define QEXTSERIALPORT_BUILD_CMDS
	$(MAKE) -C $(@D)
endef

define QEXTSERIALPORT_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/QExtSerialPort
	cp $(@D)/src/*.h $(STAGING_DIR)/usr/include/QExtSerialPort/
	cp $(@D)/src/QExtSerialPort $(STAGING_DIR)/usr/include/QExtSerialPort/
	cp -a $(@D)/src/build/*.so* $(STAGING_DIR)/usr/lib/
	cp $(@D)/qextserialport.pc $(STAGING_DIR)/usr/lib/pkgconfig/
endef

define QEXTSERIALPORT_INSTALL_TARGET_CMDS
	cp -a $(@D)/src/build/*.so.* $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
