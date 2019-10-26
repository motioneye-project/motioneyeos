################################################################################
#
# qt5webview
#
################################################################################

QT5WEBVIEW_VERSION = $(QT5_VERSION)
QT5WEBVIEW_SITE = $(QT5_SITE)
QT5WEBVIEW_SOURCE = qtwebview-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5WEBVIEW_VERSION).tar.xz
QT5WEBVIEW_DEPENDENCIES = qt5base qt5webengine
QT5WEBVIEW_INSTALL_STAGING = YES
QT5WEBVIEW_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0, GFDL-1.3 (docs)
QT5WEBVIEW_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
QT5WEBVIEW_LICENSE += , BSD-3-Clause (examples)
endif

define QT5WEBVIEW_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) $(HOST_DIR)/bin/qmake)
endef

define QT5WEBVIEW_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)
endef

define QT5WEBVIEW_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install
endef

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE_QUICK),y)
define QT5WEBVIEW_INSTALL_TARGET_QMLS
	cp -dpfr $(STAGING_DIR)/usr/qml/QtWebView $(TARGET_DIR)/usr/qml/
endef
endif

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
define QT5WEBVIEW_INSTALL_TARGET_EXAMPLES
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/examples/webview $(TARGET_DIR)/usr/lib/qt/examples/
endef
endif

ifneq ($(BR2_STATIC_LIBS),y)
define QT5WEBVIEW_INSTALL_TARGET_LIBS
	cp -dpf $(STAGING_DIR)/usr/lib/libQt5WebView.so.* $(TARGET_DIR)/usr/lib
	cp -dpfr $(STAGING_DIR)/usr/lib/qt/plugins/webview $(TARGET_DIR)/usr/lib/qt/plugins
endef
endif

define QT5WEBVIEW_INSTALL_TARGET_CMDS
	$(QT5WEBVIEW_INSTALL_TARGET_LIBS)
	$(QT5WEBVIEW_INSTALL_TARGET_QMLS)
	$(QT5WEBVIEW_INSTALL_TARGET_EXAMPLES)
endef

$(eval $(generic-package))
