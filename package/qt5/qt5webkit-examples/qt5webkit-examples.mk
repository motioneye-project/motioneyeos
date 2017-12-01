################################################################################
#
# qt5webkit-examples
#
################################################################################

# no 5.9.2 package available, fall back to 5.9.1 version
ifeq ($(BR2_PACKAGE_QT5_VERSION_LATEST),y)
QT5WEBKIT_EXAMPLES_VERSION = 5.9.1
QT5WEBKIT_EXAMPLES_SITE = http://download.qt.io/official_releases/qt/5.9/5.9.1/submodules
else
QT5WEBKIT_EXAMPLES_VERSION = $(QT5_VERSION)
QT5WEBKIT_EXAMPLES_SITE = http://download.qt.io/community_releases/5.6/$(QT5_VERSION)
endif

QT5WEBKIT_EXAMPLES_SOURCE = qtwebkit-examples-opensource-src-$(QT5WEBKIT_VERSION).tar.xz
QT5WEBKIT_EXAMPLES_DEPENDENCIES = qt5base qt5webkit

QT5WEBKIT_EXAMPLES_LICENSE_FILES = LICENSE.LGPLv21 LICENSE.LGPLv3 LICENSE.GPLv2 LICENSE.GPLv3

QT5WEBKIT_EXAMPLES_LICENSE = LGPL-2.1 with exception or LGPL-3 or GPL-2 or GPL-3
# Source files contain references to LGPL_EXCEPTION.txt but it is not included
# in the archive.

ifeq ($(BR2_PACKAGE_QT5XMLPATTERNS),y)
QT5WEBKIT_EXAMPLES_DEPENDENCIES += qt5xmlpatterns
endif

define QT5WEBKIT_EXAMPLES_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define QT5WEBKIT_EXAMPLES_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBKIT_EXAMPLES_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5WEBKIT_EXAMPLES_DEPENDENCIES += qt5declarative
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
