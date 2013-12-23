################################################################################
#
# libmicrohttpd
#
################################################################################

LIBMICROHTTPD_VERSION = 0.9.33
LIBMICROHTTPD_SITE = $(BR2_GNU_MIRROR)/libmicrohttpd
LIBMICROHTTPD_LICENSE_FILES = COPYING
LIBMICROHTTPD_INSTALL_STAGING = YES
LIBMICROHTTPD_CONF_OPT = --disable-spdy

ifeq ($(BR2_PACKAGE_LIBMICROHTTPD_SSL),y)
LIBMICROHTTPD_LICENSE = LGPLv2.1+
LIBMICROHTTPD_DEPENDENCIES += gnutls libgcrypt
LIBMICROHTTPD_CONF_OPT += --enable-https --with-gnutls=$(STAGING_DIR)/usr \
	--with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBMICROHTTPD_LICENSE = LGPLv2.1+ or eCos
LIBMICROHTTPD_CONF_OPT += --disable-https
endif

ifeq ($(BR2_avr32),y)
# no epoll_create1
LIBMICROHTTPD_CONF_OPT += --disable-epoll
endif

$(eval $(autotools-package))
