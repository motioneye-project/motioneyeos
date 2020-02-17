################################################################################
#
# qt5webview
#
################################################################################

QT5WEBVIEW_VERSION = $(QT5_VERSION)
QT5WEBVIEW_SITE = $(QT5_SITE)
QT5WEBVIEW_SOURCE = qtwebview-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5WEBVIEW_VERSION).tar.xz
QT5WEBVIEW_DEPENDENCIES = qt5webengine
QT5WEBVIEW_INSTALL_STAGING = YES
QT5WEBVIEW_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0, GFDL-1.3 (docs)
QT5WEBVIEW_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL

ifeq ($(BR2_PACKAGE_QT5BASE_EXAMPLES),y)
QT5WEBVIEW_LICENSE += , BSD-3-Clause (examples)
endif

$(eval $(qmake-package))
