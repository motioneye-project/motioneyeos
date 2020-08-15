################################################################################
#
# qt5quickcontrols2
#
################################################################################

QT5QUICKCONTROLS2_VERSION = $(QT5_VERSION)
QT5QUICKCONTROLS2_SITE = $(QT5_SITE)
QT5QUICKCONTROLS2_SOURCE = qtquickcontrols2-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5QUICKCONTROLS2_VERSION).tar.xz
QT5QUICKCONTROLS2_DEPENDENCIES = qt5declarative
QT5QUICKCONTROLS2_INSTALL_STAGING = YES

QT5QUICKCONTROLS2_LICENSE = GPL-3.0 or LGPL-3.0, GFDL-1.3 (docs)
QT5QUICKCONTROLS2_LICENSE_FILES = LICENSE.GPLv3 LICENSE.LGPLv3 LICENSE.FDL

$(eval $(qmake-package))
