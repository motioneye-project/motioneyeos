################################################################################
#
# qt5imageformats
#
################################################################################

QT5IMAGEFORMATS_VERSION = $(QT5_VERSION)
QT5IMAGEFORMATS_SITE = $(QT5_SITE)
QT5IMAGEFORMATS_SOURCE = qtimageformats-$(QT5_SOURCE_TARBALL_PREFIX)-$(QT5IMAGEFORMATS_VERSION).tar.xz
QT5IMAGEFORMATS_INSTALL_STAGING = YES

QT5IMAGEFORMATS_LICENSE = GPL-2.0+ or LGPL-3.0, GPL-3.0 with exception(tools), GFDL-1.3 (docs)
QT5IMAGEFORMATS_LICENSE_FILES = LICENSE.GPLv2 LICENSE.GPLv3 LICENSE.GPL3-EXCEPT LICENSE.LGPLv3 LICENSE.FDL

$(eval $(qmake-package))
