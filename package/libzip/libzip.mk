################################################################################
#
# libzip
#
################################################################################

LIBZIP_VERSION = 1.5.2
LIBZIP_SITE = http://www.nih.at/libzip
LIBZIP_SOURCE = libzip-$(LIBZIP_VERSION).tar.xz
LIBZIP_LICENSE = BSD-3-Clause
LIBZIP_LICENSE_FILES = LICENSE
LIBZIP_INSTALL_STAGING = YES
LIBZIP_DEPENDENCIES = zlib
HOST_LIBZIP_DEPENDENCIES = host-zlib

ifeq ($(BR2_PACKAGE_BZIP2),y)
LIBZIP_DEPENDENCIES += bzip2
else
LIBZIP_CONF_OPTS += -DCMAKE_DISABLE_FIND_PACKAGE_BZIP2=TRUE
endif

ifeq ($(BR2_PACKAGE_GNUTLS),y)
LIBZIP_DEPENDENCIES += gnutls
LIBZIP_CONF_OPTS += -DENABLE_GNUTLS=ON
else
LIBZIP_CONF_OPTS += -DENABLE_GNUTLS=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBZIP_DEPENDENCIES += openssl
LIBZIP_CONF_OPTS += -DENABLE_OPENSSL=ON
else
LIBZIP_CONF_OPTS += -DENABLE_OPENSSL=OFF
endif

ifeq ($(BR2_TOOLCHAIN_USES_GLIBC),)
LIBZIP_DEPENDENCIES += musl-fts
LIBZIP_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-lfts
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))
