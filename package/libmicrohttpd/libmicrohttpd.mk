#############################################################
#
# libmicrohttpd
#
#############################################################

LIBMICROHTTPD_VERSION = 0.9.25
LIBMICROHTTPD_SITE = $(BR2_GNU_MIRROR)/libmicrohttpd
LIBMICROHTTPD_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBMICROHTTPD_SSL),y)
LIBMICROHTTPD_DEPENDENCIES += gnutls libgcrypt
LIBMICROHTTPD_CONF_OPT += --enable-https --with-gnutls=$(STAGING_DIR)/usr \
			  --with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBMICROHTTPD_CONF_OPT += --disable-https
endif

$(eval $(autotools-package))
