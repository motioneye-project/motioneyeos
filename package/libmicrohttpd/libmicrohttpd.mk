################################################################################
#
# libmicrohttpd
#
################################################################################

LIBMICROHTTPD_VERSION = 0.9.50
LIBMICROHTTPD_SITE = $(BR2_GNU_MIRROR)/libmicrohttpd
LIBMICROHTTPD_LICENSE_FILES = COPYING
LIBMICROHTTPD_INSTALL_STAGING = YES
LIBMICROHTTPD_CONF_OPTS = --disable-curl --disable-examples
LIBMICROHTTPD_CFLAGS = $(TARGET_CFLAGS) -std=c99

# gcc on arc and bfin doesn't define _REENTRANT when -pthread is
# passed while it should. Compensate this defiency here otherwise
# libmicrohttpd configure script doesn't find that thread support is
# enabled.
ifeq ($(BR2_arc)$(BR2_bfin),y)
LIBMICROHTTPD_CFLAGS += -D_REENTRANT
endif

LIBMICROHTTPD_CONF_ENV += CFLAGS="$(LIBMICROHTTPD_CFLAGS)"

ifeq ($(BR2_PACKAGE_LIBMICROHTTPD_SSL),y)
LIBMICROHTTPD_LICENSE = LGPLv2.1+
LIBMICROHTTPD_DEPENDENCIES += host-pkgconf gnutls libgcrypt
LIBMICROHTTPD_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs gnutls`"
LIBMICROHTTPD_CONF_OPTS += --enable-https --with-gnutls=$(STAGING_DIR)/usr \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBMICROHTTPD_LICENSE = LGPLv2.1+ or eCos
LIBMICROHTTPD_CONF_OPTS += --disable-https
endif

$(eval $(autotools-package))
