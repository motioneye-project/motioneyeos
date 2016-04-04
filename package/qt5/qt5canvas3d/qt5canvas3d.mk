################################################################################
#
# qt5canvas3d
#
################################################################################

QT5CANVAS3D_VERSION = $(QT5_VERSION)
QT5CANVAS3D_SITE = $(QT5_SITE)
QT5CANVAS3D_SOURCE = qtcanvas3d-opensource-src-$(QT5CANVAS3D_VERSION).tar.xz
QT5CANVAS3D_DEPENDENCIES = qt5base qt5declarative
QT5CANVAS3D_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5CANVAS3D_LICENSE = GPLv2 or GPLv3 or LGPLv3
QT5CANVAS3D_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv3
else
QT5CANVAS3D_LICENSE = Commercial license
QT5CANVAS3D_REDISTRIBUTE = NO
endif

define QT5CANVAS3D_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5CANVAS3D_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5CANVAS3D_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

define QT5CANVAS3D_INSTALL_TARGET_CMDS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtCanvas3D $(TARGET_DIR)/usr/qml/
endef

$(eval $(generic-package))
