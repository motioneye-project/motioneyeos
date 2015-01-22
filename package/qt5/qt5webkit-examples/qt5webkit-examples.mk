################################################################################
#
# qt5webkit-examples
#
################################################################################

QT5WEBKIT_EXAMPLES_VERSION = $(QT5_VERSION)
QT5WEBKIT_EXAMPLES_SITE = $(QT5_SITE)
QT5WEBKIT_EXAMPLES_SOURCE = qtwebkit-examples-opensource-src-$(QT5WEBKIT_EXAMPLES_VERSION).tar.xz
QT5WEBKIT_EXAMPLES_DEPENDENCIES = qt5webkit

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5WEBKIT_EXAMPLES_LICENSE = LGPLv2.1 with exception or LGPLv3 or GPLv2
# Source files contain references to LGPL_EXCEPTION.txt but it is not included
# in the archive.
QT5WEBKIT_EXAMPLES_LICENSE_FILES = LICENSE.LGPLv21 LICENSE.LGPLv3 LICENSE.GPLv2
else
QT5WEBKIT_EXAMPLES_LICENSE = Commercial license
QT5WEBKIT_EXAMPLES_REDISTRIBUTE = NO
endif

ifeq ($(BR2_PACKAGE_QT5XMLPATTERNS),y)
QT5WEBKIT_EXAMPLES_DEPENDENCIES += qt5xmlpatterns
endif

define QT5WEBKIT_EXAMPLES_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5WEBKIT_EXAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBKIT_EXAMPLES_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
define QT5WEBKIT_EXAMPLES_INSTALL_QML
	cp -dpfr $(@D)/examples/webkitqml $(TARGET_DIR)/usr/lib/qt/examples
endef
endif

define QT5WEBKIT_EXAMPLES_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/qt/examples
	cp -dpfr $(@D)/examples/webkitwidgets $(TARGET_DIR)/usr/lib/qt/examples
	$(QT5WEBKIT_EXAMPLES_INSTALL_QML)
endef

$(eval $(generic-package))
