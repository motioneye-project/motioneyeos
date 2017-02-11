################################################################################
#
# qt5imageformats
#
################################################################################

QT5IMAGEFORMATS_VERSION = $(QT5_VERSION)
QT5IMAGEFORMATS_SITE = $(QT5_SITE)
QT5IMAGEFORMATS_SOURCE = qtimageformats-opensource-src-$(QT5IMAGEFORMATS_VERSION).tar.xz
QT5IMAGEFORMATS_DEPENDENCIES = qt5base
QT5IMAGEFORMATS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5IMAGEFORMATS_LICENSE = GPLv2+ or LGPLv3, GPLv3 with exception(tools), GFDLv1.3 (docs)
QT5IMAGEFORMATS_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.GPL3-EXCEPT LICENSE.LGPLv3 LICENSE.FDL
else
QT5IMAGEFORMATS_LICENSE = GPLv2 or GPLv3 or LGPLv2.1 with exception or LGPLv3, GFDLv1.3 (docs)
QT5IMAGEFORMATS_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL
endif
else
QT5IMAGEFORMATS_LICENSE = Commercial license
QT5IMAGEFORMATS_REDISTRIBUTE = NO
endif

define QT5IMAGEFORMATS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5IMAGEFORMATS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5IMAGEFORMATS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_STATIC_LIBS),)
define QT5IMAGEFORMATS_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/qt/plugins/imageformats/*.so $(TARGET_DIR)/usr/lib/qt/plugins/imageformats/
endef
endif

$(eval $(generic-package))
