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

QT5SCRIPT_LICENSE = GPL-3.0 or LGPL-2.1 with exception or LGPL-3.0, GFDL-1.3 (docs)
QT5SCRIPT_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv21 LGPL_EXCEPTION.txt LICENSE.LGPLv3 LICENSE.FDL

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
