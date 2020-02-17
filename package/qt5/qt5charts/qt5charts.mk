################################################################################
#
# qt5charts
#
################################################################################

QT5CHARTS_VERSION = $(QT5_VERSION)
QT5CHARTS_SITE = $(QT5_SITE)
QT5CHARTS_SOURCE = qtcharts-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5CHARTS_VERSION).tar.xz
QT5CHARTS_INSTALL_STAGING = YES

QT5CHARTS_LICENSE = GPL-3.0
QT5CHARTS_LICENSE_FILES = LICENSE.GPL3

ifeq ($(BR2_PACKAGE_QT5DECLARATIVE),y)
QT5CHARTS_DEPENDENCIES += qt5declarative
endif

$(eval $(qmake-package))
