################################################################################
#
# qt5serialbus
#
################################################################################

QT5SERIALBUS_VERSION = $(QT5_VERSION)
QT5SERIALBUS_SITE = $(QT5_SITE)
QT5SERIALBUS_SOURCE = qtserialbus-opensource-src-$(QT5SERIALBUS_VERSION).tar.xz
QT5SERIALBUS_DEPENDENCIES = qt5base qt5serialport
QT5SERIALBUS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5SERIALBUS_LICENSE = GPLv2 or GPLv3 or LGPLv3, GFDLv1.3 (docs)
QT5SERIALBUS_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL
else
QT5SERIALBUS_LICENSE = Commercial license
QT5SERIALBUS_REDISTRIBUTE = NO
endif

define QT5SERIALBUS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5SERIALBUS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5SERIALBUS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_STATIC_LIBS),)
define QT5SERIALBUS_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5SerialBus.so.* \
		$(TARGET_DIR)/usr/lib
	mkdir -p $(TARGET_DIR)/usr/lib/qt/plugins/canbus
	cp -dpf $(STAGING_DIR)/usr/lib/qt/plugins/canbus/*.so \
		$(TARGET_DIR)/usr/lib/qt/plugins/canbus
endef
endif

define QT5SERIALBUS_INSTALL_TARGET_CMDS
	$(QT5SERIALBUS_INSTALL_TARGET_LIBS)
	$(INSTALL) -m 0755 -D $(@D)/bin/canbusutil \
		$(TARGET_DIR)/usr/bin/canbusutil
endef

$(eval $(generic-package))
