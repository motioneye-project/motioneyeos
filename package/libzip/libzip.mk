################################################################################
#
# libzip
#
################################################################################

LIBZIP_VERSION = 1.2.0
LIBZIP_SITE = http://www.nih.at/libzip
LIBZIP_SOURCE = libzip-$(LIBZIP_VERSION).tar.xz
LIBZIP_LICENSE = BSD-3-Clause
LIBZIP_LICENSE_FILES = LICENSE
LIBZIP_INSTALL_STAGING = YES
LIBZIP_DEPENDENCIES = zlib

$(eval $(autotools-package))
