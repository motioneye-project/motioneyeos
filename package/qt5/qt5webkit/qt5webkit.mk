################################################################################
#
# qt5webkit
#
################################################################################

QT5WEBKIT_VERSION = $(QT5_VERSION)
QT5WEBKIT_SITE = $(QT5_SITE)
QT5WEBKIT_SOURCE = qtwebkit-opensource-src-$(QT5WEBKIT_VERSION).tar.xz
QT5WEBKIT_DEPENDENCIES = qt5base sqlite host-ruby host-gperf host-bison host-flex
QT5WEBKIT_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_QT5BASE_LICENSE_APPROVED),y)
QT5WEBKIT_LICENSE = LGPLv2+, MIT
else
QT5WEBKIT_LICENSE = LGPLv2+, MIT, Commercial license
QT5WEBKIT_REDISTRIBUTE = NO
endif
QT5WEBKIT_LICENSE_FILES = Source/WebCore/LICENSE-LGPL-2 Source/WebCore/LICENSE-LGPL-2.1 Source/WebKit/LICENSE

ifeq ($(BR2_PACKAGE_QT5BASE_XCB),y)
QT5WEBKIT_DEPENDENCIES += xlib_libXext xlib_libXrender
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5WEBKIT_DEPENDENCIES += qt5declarative
endif

define QT5WEBKIT_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/usr/bin/qmake)
endef

define QT5WEBKIT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBKIT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
	$(QT5_LA_PRL_FILES_FIXUP)
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5WEBKIT_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtWebKit $(TARGET_DIR)/usr/qml/
endef
endif

define QT5WEBKIT_INSTALL_TARGET_CMDS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebKit*.so.* $(TARGET_DIR)/usr/lib
	cp -dpf $(@D)/bin/* $(TARGET_DIR)/usr/bin/
	$(QT5WEBKIT_INSTALL_TARGET_QMLS)
endef

$(eval $(generic-package))
