################################################################################
#
# qt5quickcontrols
#
################################################################################

QT5QUICKCONTROLS_VERSION = $(QT5_VERSION)
QT5QUICKCONTROLS_SITE = $(QT5_SITE)
QT5QUICKCONTROLS_SOURCE = qtquickcontrols-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5QUICKCONTROLS_VERSION).tar.xz
QT5QUICKCONTROLS_DEPENDENCIES = qt5declarative
QT5QUICKCONTROLS_INSTALL_STAGING = YES

QT5QUICKCONTROLS_LICENSE = GPL-2.0 or GPL-3.0 or LGPL-3.0, GFDL-1.3 (docs)
QT5QUICKCONTROLS_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.LGPL3 LICENSE.FDL

$(eval $(qmake-package))
