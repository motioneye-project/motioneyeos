################################################################################
#
# liboauth
#
################################################################################

LIBOAUTH_VERSION = 0.9.6
LIBOAUTH_SOURCE = liboauth-$(LIBOAUTH_VERSION).tar.gz
LIBOAUTH_SITE = http://liboauth.sourceforge.net/pool
LIBOAUTH_INSTALL_STAGING = YES

LIBOAUTH_DEPENDENCIES += host-pkgconf openssl

ifeq ($(BR2_PACKAGE_LIBCURL),y)
LIBOAUTH_DEPENDENCIES += libcurl
else
LIBOAUTH_CONF_OPT += --disable-libcurl
endif

$(eval $(autotools-package))
