################################################################################
#
# qextserialport
#
################################################################################

QEXTSERIALPORT_VERSION = ada321a9ee463f628e7b781b8ed00ff219152158
QEXTSERIALPORT_SITE = $(call github,qextserialport,qextserialport,$(QEXTSERIALPORT_VERSION))
QEXTSERIALPORT_LICENSE = MIT
QEXTSERIALPORT_LICENSE_FILES = LICENSE.md
QEXTSERIALPORT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT),y)
QEXTSERIALPORT_DEPENDENCIES += qt
define QEXTSERIALPORT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT_QMAKE))
endef
else ifeq ($(BR2_PACKAGE_QT5),y)
QEXTSERIALPORT_DEPENDENCIES += qt5base
define QEXTSERIALPORT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(QT5_QMAKE))
endef
endif

define QEXTSERIALPORT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QEXTSERIALPORT_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/QExtSerialPort
	cp $(@D)/src/*.h $(STAGING_DIR)/usr/include/QExtSerialPort/
	cp $(@D)/src/QExtSerialPort $(STAGING_DIR)/usr/include/QExtSerialPort/
	cp -a $(@D)/*.so* $(STAGING_DIR)/usr/lib/
	cp $(@D)/qextserialport.pc $(STAGING_DIR)/usr/lib/pkgconfig/
endef

define QEXTSERIALPORT_INSTALL_TARGET_CMDS
	cp -a $(@D)/*.so.* $(TARGET_DIR)/usr/lib
endef

$(eval $(generic-package))
