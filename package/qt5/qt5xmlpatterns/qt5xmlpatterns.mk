################################################################################
#
# qt5xmlpatterns
#
################################################################################

QT5XMLPATTERNS_VERSION = $(QT5_VERSION)
QT5XMLPATTERNS_SITE = $(QT5_SITE)
QT5XMLPATTERNS_SOURCE = qtxmlpatterns-opensource-src-$(QT5XMLPATTERNS_VERSION).tar.xz
QT5XMLPATTERNS_DEPENDENCIES = qt5base
QT5XMLPATTERNS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5XMLPATTERNS_CONFIGURE_OPTS += -opensource -confirm-license
QT5XMLPATTERNS_LICENSE = LGPLv2.1 or GPLv3.0
QT5XMLPATTERNS_LICENSE_FILES = LICENSE.GPL LICENSE.LGPL LGPL_EXCEPTION.txt
else
QT5XMLPATTERNS_LICENSE = Commercial license
QT5XMLPATTERNS_REDISTRIBUTE = NO
endif

define QT5XMLPATTERNS_CONFIGURE_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/qmake)
endef

define QT5XMLPATTERNS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5XMLPATTERNS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PREFER_STATIC_LIB),)
define QT5XMLPATTERNS_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5XmlPatterns*.so.* $(TARGET_DIR)/usr/lib
endef
endif

$(eval $(generic-package))
