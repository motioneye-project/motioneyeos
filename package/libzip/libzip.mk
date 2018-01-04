################################################################################
#
# libzip
#
################################################################################

LIBZIP_VERSION = 1.4.0
LIBZIP_SITE = http://www.nih.at/libzip
LIBZIP_SOURCE = libzip-$(LIBZIP_VERSION).tar.xz
LIBZIP_LICENSE = BSD-3-Clause
LIBZIP_LICENSE_FILES = LICENSE
LIBZIP_INSTALL_STAGING = YES
LIBZIP_DEPENDENCIES = zlib

ifeq ($(BR2_PACKAGE_BZIP2),y)
LIBZIP_DEPENDENCIES += bzip2
else
LIBZIP_CONF_OPTS += -DCMAKE_DISABLE_FIND_PACKAGE_BZIP2=TRUE
endif

$(eval $(cmake-package))
