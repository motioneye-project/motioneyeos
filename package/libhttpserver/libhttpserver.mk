################################################################################
#
# libhttpserver
#
################################################################################

LIBHTTPSERVER_VERSION = 0.17.5
LIBHTTPSERVER_SITE = $(call github,etr,libhttpserver,$(LIBHTTPSERVER_VERSION))
LIBHTTPSERVER_LICENSE = LGPL-2.1+
LIBHTTPSERVER_LICENSE_FILES = COPYING.LESSER
LIBHTTPSERVER_INSTALL_STAGING = YES
LIBHTTPSERVER_CONF_OPTS = \
	--disable-examples \
	--enable-same-directory-build
LIBHTTPSERVER_AUTORECONF = YES
LIBHTTPSERVER_DEPENDENCIES = libmicrohttpd

$(eval $(autotools-package))
