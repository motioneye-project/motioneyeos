################################################################################
#
# qt5canvas3d
#
################################################################################

QT5CANVAS3D_VERSION = $(QT5_VERSION)
QT5CANVAS3D_SITE = $(QT5_SITE)
QT5CANVAS3D_SOURCE = qtcanvas3d-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5CANVAS3D_VERSION).tar.xz
QT5CANVAS3D_DEPENDENCIES = qt5declarative
QT5CANVAS3D_INSTALL_STAGING = YES

QT5CANVAS3D_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools)
QT5CANVAS3D_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3

$(eval $(qmake-package))
