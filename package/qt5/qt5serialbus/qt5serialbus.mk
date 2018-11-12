################################################################################
#
# qt5serialbus
#
################################################################################

QT5SERIALBUS_VERSION = $(QT5_VERSION)
QT5SERIALBUS_SITE = $(QT5_SITE)
QT5SERIALBUS_SOURCE = qtserialbus-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5SERIALBUS_VERSION).tar.xz
QT5SERIALBUS_DEPENDENCIES = qt5base qt5serialport
QT5SERIALBUS_INSTALL_STAGING = YES

QT5SERIALBUS_LICENSE = GPL-2.0 or GPL-3.0 or LGPL-3.0, GFDL-1.3 (docs)
QT5SERIALBUS_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL

define QT5SERIALBUS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
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

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES)$(BR2_PACKAGE_QT5BASE_WIDGETS),yy)
define QT5SERIALBUS_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/serialbus $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

define QT5SERIALBUS_INSTALL_TARGET_CMDS
	$(QT5SERIALBUS_INSTALL_TARGET_LIBS)
	$(QT5SERIALBUS_INSTALL_TARGET_EXAMPLES)
	$(INSTALL) -m 0755 -D $(@D)/bin/canbusutil \
		$(TARGET_DIR)/usr/bin/canbusutil
endef

$(eval $(generic-package))
