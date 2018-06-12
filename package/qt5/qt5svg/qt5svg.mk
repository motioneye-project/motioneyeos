################################################################################
#
# qt5svg
#
################################################################################

QT5SVG_VERSION = $(QT5_VERSION)
QT5SVG_SITE = $(QT5_SITE)
QT5SVG_SOURCE = qtsvg-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5SVG_VERSION).tar.xz
QT5SVG_DEPENDENCIES = qt5base
QT5SVG_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5SVG_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5SVG_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL
else
QT5SVG_LICENSE = GPL-3.0 or LGPL-2.1 with exception or LGPL-3.0, GFDL-1.3 (docs)
QT5SVG_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
endif

define QT5SVG_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define QT5SVG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5SVG_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5BASE_WIDGETS),y)
define QT5SVG_INSTALL_ICONENGINES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/iconengines $(TARGET_DIR)/usr/lib/qt/plugins
endef
endif

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5SVG_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/svg $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

ifeq ($(BR2_STATIC_LIBS),)
define QT5SVG_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Svg*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(STAGING_DIR)/usr/lib/qt/plugins/imageformats/libqsvg.so $(TARGET_DIR)/usr/lib/qt/plugins/imageformats/
	$(QT5SVG_INSTALL_ICONENGINES)
endef
endif

define QT5SVG_INSTALL_TARGET_CMDS
	$(QT5SVG_INSTALL_TARGET_LIBS)
	$(QT5SVG_INSTALL_TARGET_EXAMPLES)
endef

$(eval $(generic-package))
