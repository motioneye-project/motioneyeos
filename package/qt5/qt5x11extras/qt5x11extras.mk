################################################################################
#
# qt5x11extras
#
################################################################################

QT5X11EXTRAS_VERSION = $(QT5_VERSION)
QT5X11EXTRAS_SITE = $(QT5_SITE)
QT5X11EXTRAS_SOURCE = qtx11extras-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5X11EXTRAS_VERSION).tar.xz
QT5X11EXTRAS_INSTALL_STAGING = YES
QT5X11EXTRAS_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5X11EXTRAS_LICENSE_FILES = LICENSE.GPL2 LICENSE.GPL3 LICENSE.GPL3-EXCEPT LICENSE.LGPL3 LICENSE.FDL

$(eval $(qmake-package))
