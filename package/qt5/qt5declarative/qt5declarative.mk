################################################################################
#
# qt5declarative
#
################################################################################

QT5DECLARATIVE_VERSION = $(QT5_VERSION)
QT5DECLARATIVE_SITE = $(QT5_SITE)
QT5DECLARATIVE_SOURCE = qtdeclarative-opensource-src-$(QT5DECLARATIVE_VERSION).tar.xz
QT5DECLARATIVE_DEPENDENCIES = qt5base qt5xmlpatterns
QT5DECLARATIVE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5DECLARATIVE_LICENSE = GPLv2+ or LGPLv3, GPLv3 with exception(tools), GFDLv1.3 (docs)
QT5DECLARATIVE_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPLv3 LICENSE.GPL3-EXCEPT LICENSE.LGPLv3 LICENSE.FDL
else
QT5DECLARATIVE_LICENSE = GPLv3 or LGPLv2.1 with exception or LGPLv3, GFDLv1.3 (docs)
QT5DECLARATIVE_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
endif
else
QT5DECLARATIVE_LICENSE = Commercial license
QT5DECLARATIVE_REDISTRIBUTE = NO
endif

define QT5DECLARATIVE_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5DECLARATIVE_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		sub-src-all sub-tools-all
endef

define QT5DECLARATIVE_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		sub-src-install_subtargets \
		sub-tools-install_subtargets
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_STATIC_LIBS),)

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5DECLARATIVE_INSTALL_TARGET_QUICK_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Quick*.so.* $(TARGET_DIR)/usr/lib
endef
endif

define QT5DECLARATIVE_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Qml*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/qml* $(TARGET_DIR)/usr/lib/qt/plugins
	$(QT5DECLARATIVE_INSTALL_TARGET_QUICK_LIBS)
endef

endif

define QT5DECLARATIVE_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/bin/qml* $(TARGET_DIR)/usr/bin
	cp -dpfr $(STAGING_DIR)/usr/qml $(TARGET_DIR)/usr
	$(QT5DECLARATIVE_INSTALL_TARGET_LIBS)
endef

$(eval $(generic-package))
