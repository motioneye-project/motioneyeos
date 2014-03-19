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

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5QUICKCONTROLS_LICENSE = LGPLv2.1 or GPLv3.0
QT5QUICKCONTROLS_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5QUICKCONTROLS_LICENSE = Commercial license
QT5QUICKCONTROLS_REDISTRIBUTE = NO
endif

define QT5QUICKCONTROLS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5QUICKCONTROLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5QUICKCONTROLS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

define QT5QUICKCONTROLS_INSTALL_TARGET_CMDS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtQuick $(TARGET_DIR)/usr/qml
endef

$(eval $(generic-package))
