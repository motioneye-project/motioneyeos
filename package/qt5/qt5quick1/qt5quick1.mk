################################################################################
#
# qt5quick1
#
################################################################################

QT5QUICK1_VERSION = $(QT5_VERSION)
QT5QUICK1_SITE = $(QT5_SITE)
QT5QUICK1_SOURCE = qtquick1-opensource-src-$(QT5QUICK1_VERSION).tar.xz
QT5QUICK1_DEPENDENCIES = qt5base qt5xmlpatterns qt5script qt5declarative \
	$(if $(BR2_PACKAGE_QT5WEBKIT),qt5webkit)
QT5QUICK1_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5QUICK1_LICENSE = LGPLv2.1 or GPLv3.0
QT5QUICK1_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5QUICK1_LICENSE = Commercial license
QT5QUICK1_REDISTRIBUTE = NO
endif

define QT5QUICK1_CONFIGURE_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/qmake)
endef

define QT5QUICK1_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5QUICK1_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

define QT5QUICK1_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Declarative.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/qml1tooling $(TARGET_DIR)/usr/lib/qt/plugins/
	cp -dpfr $(STAGING_DIR)/usr/imports $(TARGET_DIR)/usr
endef

$(eval $(generic-package))
