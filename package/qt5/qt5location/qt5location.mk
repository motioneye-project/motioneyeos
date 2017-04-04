################################################################################
#
# qt5location
#
################################################################################

QT5LOCATION_VERSION = $(QT5_VERSION)
QT5LOCATION_SITE = $(QT5_SITE)
QT5LOCATION_SOURCE = qtlocation-opensource-src-$(QT5LOCATION_VERSION).tar.xz
QT5LOCATION_DEPENDENCIES = qt5base
QT5LOCATION_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5LOCATION_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5LOCATION_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.GPL3-EXCEPT LICENSE.LGPLv3 LICENSE.FDL
else
QT5LOCATION_LICENSE = GPL-2.0 or GPL-3.0 or LGPL-2.1 with exception or LGPL-3.0, GFDL-1.3 (docs)
QT5LOCATION_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
endif
else
QT5LOCATION_LICENSE = Commercial license
QT5LOCATION_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5LOCATION_DEPENDENCIES += qt5declarative
endif

define QT5LOCATION_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5LOCATION_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5LOCATION_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5LOCATION_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtPositioning $(TARGET_DIR)/usr/qml/
	cp -dpfr $(STAGING_DIR)/usr/qml/QtLocation $(TARGET_DIR)/usr/qml/
endef
define QT5LOCATION_INSTALL_TARGET_LOCATION
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Location.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/geoservices $(TARGET_DIR)/usr/lib/qt/plugins/
endef
endif

define QT5LOCATION_INSTALL_TARGET_POSITION
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Positioning.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/position $(TARGET_DIR)/usr/lib/qt/plugins/
endef

define QT5LOCATION_INSTALL_TARGET_CMDS
	$(QT5LOCATION_INSTALL_TARGET_POSITION)
	$(QT5LOCATION_INSTALL_TARGET_LOCATION)
	$(QT5LOCATION_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))
