#############################################################
#
# libmicrohttpd
#
#############################################################
LIBMICROHTTPD_VERSION = 0.4.6
LIBMICROHTTPD_SOURCE = libmicrohttpd-$(LIBMICROHTTPD_VERSION).tar.gz
LIBMICROHTTPD_SITE = $(BR2_GNU_MIRROR)/libmicrohttpd
LIBMICROHTTPD_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBMICROHTTPD_SSL),y)
LIBMICROHTTPD_DEPENDENCIES += libgcrypt
LIBMICROHTTPD_CONF_OPT += --enable-https \
			  --with-libgcrypt-prefix=$(STAGING_DIR)/usr
else
LIBMICROHTTPD_CONF_OPT += --disable-https
endif

$(eval $(autotools-package))
