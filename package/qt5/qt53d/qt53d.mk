################################################################################
#
# qt53d
#
################################################################################

QT53D_VERSION = $(QT5_VERSION)
QT53D_SITE = $(QT5_SITE)
QT53D_SOURCE = qt3d-opensource-src-$(QT5SVG_VERSION).tar.xz
QT53D_DEPENDENCIES = qt5base qt5declarative
QT53D_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT53D_LICENSE = GPLv2+ or LGPLv3
QT53D_LICENSE_FILES = LICENSE.GPL LICENSE.LGPLv3
else
QT53D_LICENSE = Commercial license
QT53D_REDISTRIBUTE = NO
endif

define QT53D_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT53D_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT53D_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_STATIC_LIBS),)
define QT53D_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt53D*.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/qml/Qt3D $(TARGET_DIR)/usr/qml
endef
endif

$(eval $(generic-package))
