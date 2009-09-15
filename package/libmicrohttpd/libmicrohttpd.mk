#############################################################
#
# libmicrohttpd
#
#############################################################
LIBMICROHTTPD_VERSION:=0.4.2
LIBMICROHTTPD_SOURCE:=libmicrohttpd-$(LIBMICROHTTPD_VERSION).tar.gz
LIBMICROHTTPD_SITE:=$(BR2_GNU_MIRROR)/libmicrohttpd
LIBMICROHTTPD_LIBTOOL_PATCH = NO
LIBMICROHTTPD_INSTALL_STAGING = YES

LIBMICROHTTPD_DEPENDENCIES = libgcrypt

$(eval $(call AUTOTARGETS,package,libmicrohttpd))
