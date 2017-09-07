################################################################################
#
# libzip
#
################################################################################

LIBZIP_VERSION = 1.3.0
LIBZIP_SITE = http://www.nih.at/libzip
LIBZIP_SOURCE = libzip-$(LIBZIP_VERSION).tar.xz
LIBZIP_LICENSE = BSD-3-Clause
LIBZIP_LICENSE_FILES = LICENSE
LIBZIP_INSTALL_STAGING = YES
LIBZIP_DEPENDENCIES = zlib

ifeq ($(BR2_PACKAGE_BZIP2),y)
LIBZIP_CONF_OPTS += --with-bzip2
LIBZIP_DEPENDENCIES += bzip2
else
LIBZIP_CONF_OPTS += --without-bzip2
endif

$(eval $(autotools-package))
