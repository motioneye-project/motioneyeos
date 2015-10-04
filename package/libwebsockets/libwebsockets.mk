################################################################################
#
# libwebsockets
#
################################################################################

LIBWEBSOCKETS_VERSION = v1.4-chrome43-firefox-36
LIBWEBSOCKETS_SOURCE = libwebsockets-$(LIBWEBSOCKETS_VERSION).tar.xz
LIBWEBSOCKETS_SITE = http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot
LIBWEBSOCKETS_LICENSE = LGPLv2.1 with exceptions
LIBWEBSOCKETS_LICENSE_FILES = LICENSE
LIBWEBSOCKETS_DEPENDENCIES = zlib
LIBWEBSOCKETS_INSTALL_STAGING = YES
LIBWEBSOCKETS_CONF_OPTS = -DLWS_WITHOUT_TESTAPPS=ON -DLWS_IPV6=ON

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBWEBSOCKETS_DEPENDENCIES += openssl host-openssl
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_SSL=ON
else
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_SSL=OFF
endif

$(eval $(cmake-package))
