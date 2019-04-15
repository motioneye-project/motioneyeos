################################################################################
#
# qt5canvas3d
#
################################################################################

QT5CANVAS3D_VERSION = $(QT5_VERSION)
QT5CANVAS3D_SITE = $(QT5_SITE)
QT5CANVAS3D_SOURCE = qtcanvas3d-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5CANVAS3D_VERSION).tar.xz
QT5CANVAS3D_DEPENDENCIES = qt5base qt5declarative
QT5CANVAS3D_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5CANVAS3D_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools)
QT5CANVAS3D_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3
else
QT5CANVAS3D_LICENSE = GPL-2.0 or GPL-3.0 or LGPL-3.0
QT5CANVAS3D_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv3
endif

define QT5CANVAS3D_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define QT5CANVAS3D_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5CANVAS3D_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5CANVAS3D_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/canvas3d $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

define QT5CANVAS3D_INSTALL_TARGET_CMDS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtCanvas3D $(TARGET_DIR)/usr/qml/
	$(QT5CANVAS3D_INSTALL_TARGET_EXAMPLES)
endef

$(eval $(generic-package))
