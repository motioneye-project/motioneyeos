################################################################################
#
# libwebsock
#
################################################################################

LIBWEBSOCK_VERSION = 3c1615eeadb0b582b63851073bfe3e5132f31ebc
LIBWEBSOCK_SITE = $(call github,payden,libwebsock,$(LIBWEBSOCK_VERSION))
LIBWEBSOCK_DEPENDENCIES = libevent host-pkgconf
LIBWEBSOCK_AUTORECONF = YES
LIBWEBSOCK_INSTALL_STAGING = YES
LIBWEBSOCK_LICENSE = LGPL-3.0
LIBWEBSOCK_LICENSE_FILES = COPYING.lesser

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBWEBSOCK_DEPENDENCIES += openssl
LIBWEBSOCK_CONF_OPTS += --with-ssl
else
LIBWEBSOCK_CONF_OPTS += --without-ssl
endif

$(eval $(autotools-package))
