################################################################################
#
# wget
#
################################################################################

WGET_VERSION = 1.20.3
WGET_SOURCE = wget-$(WGET_VERSION).tar.lz
WGET_SITE = $(BR2_GNU_MIRROR)/wget
WGET_DEPENDENCIES = host-pkgconf
WGET_LICENSE = GPL-3.0+
WGET_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_GNUTLS),y)
WGET_CONF_OPTS += --with-ssl=gnutls
WGET_DEPENDENCIES += gnutls
else ifeq ($(BR2_PACKAGE_OPENSSL),y)
WGET_CONF_OPTS += --with-ssl=openssl
WGET_DEPENDENCIES += openssl
else
WGET_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
WGET_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_LIBIDN2),y)
WGET_CONF_OPTS += --with-libidn
WGET_DEPENDENCIES += libidn2
else
WGET_CONF_OPTS += --without-libidn
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBUUID),y)
WGET_DEPENDENCIES += util-linux
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
WGET_CONF_OPTS += --with-zlib
WGET_DEPENDENCIES += zlib
else
WGET_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_PCRE2),y)
WGET_CONF_OPTS += --disable-pcre --enable-pcre2
WGET_DEPENDENCIES += pcre2
else ifeq ($(BR2_PACKAGE_PCRE),y)
WGET_CONF_OPTS += --enable-pcre --disable-pcre2
WGET_DEPENDENCIES += pcre
else
WGET_CONF_OPTS += --disable-pcre --disable-pcre2
endif

$(eval $(autotools-package))
