################################################################################
#
# janus-gateway
#
################################################################################

JANUS_GATEWAY_VERSION = c632c1e9da5ffd8c34df6086a1aa5a8511a2a02d
JANUS_GATEWAY_SITE = $(call github,meetecho,janus-gateway,$(JANUS_GATEWAY_VERSION))
JANUS_GATEWAY_LICENSE = GPLv3
JANUS_GATEWAY_LICENSE_FILES = COPYING

# ding-libs provides the ini_config library
JANUS_GATEWAY_DEPENDENCIES = host-pkgconf libmicrohttpd jansson \
	libnice sofia-sip libsrtp host-gengetopt openssl ding-libs

# Straight out of the repository, no ./configure, and we also patch
# configure.ac.
JANUS_GATEWAY_AUTORECONF = YES

define JANUS_GATEWAY_M4
        mkdir -p $(@D)/m4
endef
JANUS_GATEWAY_POST_PATCH_HOOKS += JANUS_GATEWAY_M4

JANUS_GATEWAY_CONF_OPTS = \
	--disable-data-channels \
	--disable-rabbitmq

ifeq ($(BR2_PACKAGE_LIBWEBSOCK),y)
JANUS_GATEWAY_DEPENDENCIES += libwebsock
JANUS_GATEWAY_CONF_OPTS += --enable-websockets
else
JANUS_GATEWAY_CONF_OPTS += --disable-websockets
endif

ifeq ($(BR2_PACKAGE_OPUS),y)
JANUS_GATEWAY_DEPENDENCIES += opus
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-audiobridge
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-audiobridge
endif

ifeq ($(BR2_PACKAGE_LIBOGG),y)
JANUS_GATEWAY_DEPENDENCIES += libogg
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-voicemail
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-voicemail
endif

# Parallel build broken
JANUS_GATEWAY_MAKE = $(MAKE1)

$(eval $(autotools-package))
