################################################################################
#
# qt5x11extras
#
################################################################################

QT5X11EXTRAS_VERSION = $(QT5_VERSION)
QT5X11EXTRAS_SITE = $(QT5_SITE)
QT5X11EXTRAS_SOURCE = qtx11extras-opensource-src-$(QT5X11EXTRAS_VERSION).tar.xz
QT5X11EXTRAS_DEPENDENCIES = qt5base
QT5X11EXTRAS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5X11EXTRAS_LICENSE = LGPLv2.1 or GPLv3.0
QT5X11EXTRAS_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5X11EXTRAS_LICENSE = Commercial license
QT5X11EXTRAS_REDISTRIBUTE = NO
endif

define QT5X11EXTRAS_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5X11EXTRAS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5X11EXTRAS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PREFER_STATIC_LIB),)
define QT5X11EXTRAS_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5X11Extras.so.* $(TARGET_DIR)/usr/lib
endef
endif

$(eval $(generic-package))
