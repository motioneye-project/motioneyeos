################################################################################
#
# liboauth
#
################################################################################

LIBOAUTH_VERSION = 1.0.3
LIBOAUTH_SITE = http://downloads.sourceforge.net/project/liboauth
LIBOAUTH_INSTALL_STAGING = YES
LIBOAUTH_DEPENDENCIES += host-pkgconf openssl
LIBOAUTH_LICENSE = MIT
LIBOAUTH_LICENSE_FILES = COPYING.MIT

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LIBOAUTH_DEPENDENCIES += libcurl
else
LIBOAUTH_CONF_OPTS += --disable-libcurl
endif

$(eval $(autotools-package))
