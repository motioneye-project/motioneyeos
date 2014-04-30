################################################################################
#
# libwebsockets
#
################################################################################

LIBWEBSOCKETS_VERSION = v1.23-chrome32-firefox24
LIBWEBSOCKETS_SOURCE = libwebsockets-$(LIBWEBSOCKETS_VERSION).tar.xz
LIBWEBSOCKETS_SITE = http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot
LIBWEBSOCKETS_LICENSE = LGPLv2.1 with exceptions
LIBWEBSOCKETS_LICENSE_FILES = LICENSE
LIBWEBSOCKETS_DEPENDENCIES = zlib
LIBWEBSOCKETS_INSTALL_STAGING = YES

LIBWEBSOCKETS_CONF_OPT += -DWITHOUT_TESTAPPS=ON

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBWEBSOCKETS_DEPENDENCIES += openssl
else
LIBWEBSOCKETS_CONF_OPT += -DWITH_SSL=OFF
endif

$(eval $(cmake-package))
