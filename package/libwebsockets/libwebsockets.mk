################################################################################
#
# libwebsockets
#
################################################################################

LIBWEBSOCKETS_VERSION = v1.3-chrome37-firefox30
LIBWEBSOCKETS_SOURCE = libwebsockets-$(LIBWEBSOCKETS_VERSION).tar.xz
LIBWEBSOCKETS_SITE = http://git.libwebsockets.org/cgi-bin/cgit/libwebsockets/snapshot
LIBWEBSOCKETS_LICENSE = LGPLv2.1 with exceptions
LIBWEBSOCKETS_LICENSE_FILES = LICENSE
LIBWEBSOCKETS_DEPENDENCIES = zlib
LIBWEBSOCKETS_INSTALL_STAGING = YES

LIBWEBSOCKETS_CONF_OPTS += -DWITHOUT_TESTAPPS=ON

ifeq ($(BR2_INET_IPV6),y)
LIBWEBSOCKETS_CONF_OPTS += -DLWS_IPV6=ON
else
LIBWEBSOCKETS_CONF_OPTS += -DLWS_IPV6=OFF
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBWEBSOCKETS_DEPENDENCIES += openssl host-openssl
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_SSL=ON
else
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_SSL=OFF
endif

$(eval $(cmake-package))
