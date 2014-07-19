################################################################################
#
# qt5sensors
#
################################################################################

QT5SENSORS_VERSION = $(QT5_VERSION)
QT5SENSORS_SITE = $(QT5_SITE)
QT5SENSORS_SOURCE = qtsensors-opensource-src-$(QT5SENSORS_VERSION).tar.xz
QT5SENSORS_DEPENDENCIES = qt5base
QT5SENSORS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5SENSORS_LICENSE = LGPLv2.1 or GPLv3.0
QT5SENSORS_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5SENSORS_LICENSE = Commercial license
QT5SENSORS_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5SENSORS_DEPENDENCIES += qt5declarative
endif

define QT5SENSORS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5SENSORS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5SENSORS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PREFER_STATIC_LIB),)
define QT5SENSORS_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Sensors.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/sensor* $(TARGET_DIR)/usr/lib/qt/plugins
endef
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5SENSORS_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtSensors $(TARGET_DIR)/usr/qml
endef
endif

define QT5SENSORS_INSTALL_TARGET_CMDS
	$(QT5SENSORS_INSTALL_TARGET_LIBS)
	$(QT5SENSORS_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))
