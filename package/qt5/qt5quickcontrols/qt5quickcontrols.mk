################################################################################
#
# qt5quickcontrols
#
################################################################################

QT5QUICKCONTROLS_VERSION = $(QT5_VERSION)
QT5QUICKCONTROLS_SITE = $(QT5_SITE)
QT5QUICKCONTROLS_SOURCE = qtquickcontrols-opensource-src-$(QT5QUICKCONTROLS_VERSION).tar.xz
QT5QUICKCONTROLS_DEPENDENCIES = qt5base qt5declarative
QT5QUICKCONTROLS_INSTALL_STAGING = YES

QT5QUICKCONTROLS_LICENSE = GPL-2.0 or GPL-3.0 or LGPL-3.0, GFDL-1.3 (docs)
QT5QUICKCONTROLS_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL

define QT5QUICKCONTROLS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5QUICKCONTROLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5QUICKCONTROLS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK)$(BR2_PACKAGE_QT5BASE_WIDGETS),yy)
define QT5QUICKCONTROLS_INSTALL_TARGET_PRIVATEWIDGETS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/PrivateWidgets $(TARGET_DIR)/usr/qml/QtQuick
endef
endif

ifeq ($(BR2_PACKAGE_QT5_VERSION_5_6),y)
define QT5QUICKCONTROLS_INSTALL_TARGET_LAYOUTS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/Layouts $(TARGET_DIR)/usr/qml/QtQuick
endef
endif

define QT5QUICKCONTROLS_INSTALL_TARGET_CMDS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/Controls $(TARGET_DIR)/usr/qml/QtQuick
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/Dialogs $(TARGET_DIR)/usr/qml/QtQuick
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick/Extras $(TARGET_DIR)/usr/qml/QtQuick
	$(QT5QUICKCONTROLS_INSTALL_TARGET_PRIVATEWIDGETS)
	$(QT5QUICKCONTROLS_INSTALL_TARGET_LAYOUTS)
endef

$(eval $(generic-package))
