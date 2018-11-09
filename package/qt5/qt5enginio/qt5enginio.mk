################################################################################
#
# qt5enginio
#
################################################################################

# Qt5Enginio does not follow Qt versionning
# see https://bugreports.qt.io/browse/QTBUG-50111
QT5ENGINIO_VERSION = 1.6.3
QT5ENGINIO_SITE = $(QT5_SITE)
QT5ENGINIO_SOURCE = qtenginio-opensource-src-$(QT5ENGINIO_VERSION).tar.xz
QT5ENGINIO_DEPENDENCIES = openssl qt5base
QT5ENGINIO_INSTALL_STAGING = YES

QT5ENGINIO_LICENSE = GPL-3.0 or LGPL-2.1 with exception or LGPL-3.0, GFDL-1.3 (docs)
QT5ENGINIO_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
QT5ENGINIO_LICENSE := $(QT5ENGINIO_LICENSE), BSD-3-Clause (examples)
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5ENGINIO_DEPENDENCIES += qt5declarative
endif

define QT5ENGINIO_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define QT5ENGINIO_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5ENGINIO_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5ENGINIO_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/Enginio $(TARGET_DIR)/usr/qml/
endef
endif

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5ENGINIO_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/enginio $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

ifneq ($(BR2_STATIC_LIBS),y)
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
