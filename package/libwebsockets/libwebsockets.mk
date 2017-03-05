################################################################################
#
# libwebsockets
#
################################################################################

LIBWEBSOCKETS_VERSION = v2.1.1
LIBWEBSOCKETS_SITE = $(call github,warmcat,libwebsockets,$(LIBWEBSOCKETS_VERSION))
LIBWEBSOCKETS_LICENSE = LGPLv2.1 with exceptions
LIBWEBSOCKETS_LICENSE_FILES = LICENSE
LIBWEBSOCKETS_DEPENDENCIES = zlib
LIBWEBSOCKETS_INSTALL_STAGING = YES
LIBWEBSOCKETS_CONF_OPTS = -DLWS_WITHOUT_TESTAPPS=ON -DLWS_IPV6=ON

# If LWS_MAX_SMP=1, then there is no code related to pthreads compiled
# in the library. If unset, LWS_MAX_SMP defaults to 32 and a small
# amount of pthread mutex code is built into the library.
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
LIBWEBSOCKETS_CONF_OPTS += -DLWS_MAX_SMP=1
else
LIBWEBSOCKETS_CONF_OPTS += -DLWS_MAX_SMP=
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBWEBSOCKETS_DEPENDENCIES += openssl host-openssl
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_SSL=ON
else
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_SSL=OFF
endif

ifeq ($(BR2_PACKAGE_LIBEV),y)
LIBWEBSOCKETS_DEPENDENCIES += libev
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_LIBEV=ON
else
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_LIBEV=OFF
endif

ifeq ($(BR2_PACKAGE_LIBUV),y)
LIBWEBSOCKETS_DEPENDENCIES += libuv
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_LIBUV=ON
else
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_LIBUV=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_SHARED=OFF
endif

ifeq ($(BR2_SHARED_LIBS),y)
LIBWEBSOCKETS_CONF_OPTS += -DLWS_WITH_STATIC=OFF
endif

$(eval $(cmake-package))
