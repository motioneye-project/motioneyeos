################################################################################
#
# libzip
#
################################################################################

LIBZIP_VERSION = 0.11.2
LIBZIP_SITE = http://www.nih.at/libzip
LIBZIP_SOURCE = libzip-$(LIBZIP_VERSION).tar.xz
LIBZIP_LICENSE = BSD-3c
LIBZIP_LICENSE_FILES = LICENSE
LIBZIP_INSTALL_STAGING = YES
LIBZIP_DEPENDENCIES = zlib

$(eval $(autotools-package))
