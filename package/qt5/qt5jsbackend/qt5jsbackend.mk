################################################################################
#
# qt5jsbackend
#
################################################################################

QT5JSBACKEND_VERSION = $(QT5_VERSION)
QT5JSBACKEND_SITE = $(QT5_SITE)
QT5JSBACKEND_SOURCE = qtjsbackend-opensource-src-$(QT5JSBACKEND_VERSION).tar.xz
QT5JSBACKEND_DEPENDENCIES = qt5base
QT5JSBACKEND_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5JSBACKEND_LICENSE = LGPLv2.1 or GPLv3.0
QT5JSBACKEND_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5JSBACKEND_LICENSE = Commercial license
QT5JSBACKEND_REDISTRIBUTE = NO
endif

define QT5JSBACKEND_CONFIGURE_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/qmake)
endef

define QT5JSBACKEND_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5JSBACKEND_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PREFER_STATIC_LIB),)
define QT5JSBACKEND_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5V8*.so.* $(TARGET_DIR)/usr/lib
endef
endif

$(eval $(generic-package))
