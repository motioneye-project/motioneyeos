################################################################################
#
# qt5declarative
#
################################################################################

QT5DECLARATIVE_VERSION = $(QT5_VERSION)
QT5DECLARATIVE_SITE = $(QT5_SITE)
QT5DECLARATIVE_SOURCE = qtdeclarative-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5DECLARATIVE_VERSION).tar.xz
QT5DECLARATIVE_DEPENDENCIES = qt5base qt5xmlpatterns
QT5DECLARATIVE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5DECLARATIVE_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5DECLARATIVE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3 LICENSE.FDL
else
QT5DECLARATIVE_LICENSE = GPL-3.0 or LGPL-2.1 with exception or LGPL-3.0, GFDL-1.3 (docs)
QT5DECLARATIVE_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
endif

define QT5DECLARATIVE_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define QT5DECLARATIVE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5DECLARATIVE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_STATIC_LIBS),)

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5DECLARATIVE_INSTALL_TARGET_QUICK_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Quick*.so.* $(TARGET_DIR)/usr/lib
endef
define QT5DECLARATIVE_INSTALL_TARGET_QUICK_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/quick/ $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

define QT5DECLARATIVE_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Qml*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/qml* $(TARGET_DIR)/usr/lib/qt/plugins
	$(QT5DECLARATIVE_INSTALL_TARGET_QUICK_LIBS)
endef

endif

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5DECLARATIVE_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/qml* $(TARGET_DIR)/usr/lib/qt/examples/
	$(QT5DECLARATIVE_INSTALL_TARGET_QUICK_EXAMPLES)
endef
endif

define QT5DECLARATIVE_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/bin/qml* $(TARGET_DIR)/usr/bin
	cp -dpfr $(STAGING_DIR)/usr/qml $(TARGET_DIR)/usr
	$(QT5DECLARATIVE_INSTALL_TARGET_EXAMPLES)
	$(QT5DECLARATIVE_INSTALL_TARGET_LIBS)
endef

$(eval $(generic-package))
