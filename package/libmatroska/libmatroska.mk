################################################################################
#
# libmatroska
#
################################################################################

LIBMATROSKA_VERSION = 1.4.9
LIBMATROSKA_SOURCE = libmatroska-$(LIBMATROSKA_VERSION).tar.xz
LIBMATROSKA_SITE = http://dl.matroska.org/downloads/libmatroska
LIBMATROSKA_INSTALL_STAGING = YES
LIBMATROSKA_LICENSE = LGPL-2.1+
LIBMATROSKA_LICENSE_FILES = LICENSE.LGPL
LIBMATROSKA_DEPENDENCIES = libebml host-pkgconf

$(eval $(cmake-package))
