################################################################################
#
# qt5connectivity
#
################################################################################

QT5CONNECTIVITY_VERSION = $(QT5_VERSION)
QT5CONNECTIVITY_SITE = $(QT5_SITE)
QT5CONNECTIVITY_SOURCE = qtconnectivity-opensource-src-$(QT5CONNECTIVITY_VERSION).tar.xz
QT5CONNECTIVITY_DEPENDENCIES = bluez_utils qt5base
QT5CONNECTIVITY_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5CONNECTIVITY_LICENSE = GPLv2 or GPLv3 or LGPLv2.1 with exception or LGPLv3, GFDLv1.3 (docs)
QT5CONNECTIVITY_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
else
QT5CONNECTIVITY_LICENSE = Commercial license
QT5CONNECTIVITY_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5CONNECTIVITY_DEPENDENCIES += qt5declarative
endif

define QT5CONNECTIVITY_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5CONNECTIVITY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5CONNECTIVITY_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5CONNECTIVITY_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtBluetooth $(TARGET_DIR)/usr/qml/
endef
endif

define QT5CONNECTIVITY_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Bluetooth.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/bin/sdpscanner $(TARGET_DIR)/usr/bin
	$(QT5CONNECTIVITY_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))
