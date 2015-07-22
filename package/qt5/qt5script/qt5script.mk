################################################################################
#
# qt5script
#
################################################################################

QT5SCRIPT_VERSION = $(QT5_VERSION)
QT5SCRIPT_SITE = $(QT5_SITE)
QT5SCRIPT_SOURCE = qtscript-opensource-src-$(QT5SCRIPT_VERSION).tar.xz
QT5SCRIPT_DEPENDENCIES = qt5base
QT5SCRIPT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5SCRIPT_LICENSE = LGPLv2.1 with exception or LGPLv3
QT5SCRIPT_LICENSE_FILES = LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3
else
QT5SCRIPT_LICENSE = Commercial license
QT5SCRIPT_REDISTRIBUTE = NO
endif

define QT5SCRIPT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5SCRIPT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5SCRIPT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_STATIC_LIBS),)
define QT5SCRIPT_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5Script*.so.* $(TARGET_DIR)/usr/lib
endef
endif

$(eval $(generic-package))
