################################################################################
#
# qt5enginio
#
################################################################################

QT5ENGINIO_VERSION = $(QT5_VERSION)
QT5ENGINIO_SITE = $(QT5_SITE)
QT5ENGINIO_SOURCE = qtenginio-opensource-src-$(QT5ENGINIO_VERSION).tar.xz
QT5ENGINIO_DEPENDENCIES = openssl qt5base
QT5ENGINIO_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5ENGINIO_LICENSE = LGPLv2.1 or GPLv3.0
QT5ENGINIO_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5ENGINIO_LICENSE = Commercial license
QT5ENGINIO_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5ENGINIO_DEPENDENCIES += qt5declarative
endif

define QT5ENGINIO_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5ENGINIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5ENGINIO_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
define QT5ENGINIO_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/Enginio $(TARGET_DIR)/usr/qml/
endef
endif

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5ENGINIO_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/enginio $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

ifneq ($(BR2_PREFER_STATIC_LIB),y)
define QT5ENGINIO_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libEnginio.so.* $(TARGET_DIR)/usr/lib
endef
endif

define QT5ENGINIO_INSTALL_TARGET_CMDS
	$(QT5ENGINIO_INSTALL_TARGET_LIBS)
	$(QT5ENGINIO_INSTALL_TARGET_QMLS)
	$(QT5ENGINIO_INSTALL_TARGET_EXAMPLES)
endef

$(eval $(generic-package))
