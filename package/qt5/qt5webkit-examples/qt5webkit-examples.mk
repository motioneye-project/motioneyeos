################################################################################
#
# qt5webkit-examples
#
################################################################################

QT5WEBKIT_EXAMPLES_VERSION = 5.9.1
QT5WEBKIT_EXAMPLES_SITE = https://download.qt.io/official_releases/qt/5.9/5.9.1/submodules
QT5WEBKIT_EXAMPLES_SOURCE = qtwebkit-examples-opensource-src-$(QT5WEBKIT_VERSION).tar.xz
QT5WEBKIT_EXAMPLES_DEPENDENCIES = qt5webkit

QT5WEBKIT_EXAMPLES_LICENSE_FILES = LICENSE.LGPLv21 LICENSE.LGPLv3 LICENSE.GPLv2 LICENSE.GPLv3

QT5WEBKIT_EXAMPLES_LICENSE = LGPL-2.1 with exception or LGPL-3 or GPL-2 or GPL-3
# Source files contain references to LGPL_EXCEPTION.txt but it is not included
# in the archive.

ifeq ($(BR2_PACKAGE_QT5XMLPATTERNS),y)
QT5WEBKIT_EXAMPLES_DEPENDENCIES += qt5xmlpatterns
endif

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5WEBKIT_EXAMPLES_DEPENDENCIES += qt5declarative
endif

$(eval $(qmake-package))
