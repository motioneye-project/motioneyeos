################################################################################
#
# janus-gateway
#
################################################################################

JANUS_GATEWAY_VERSION = v0.2.6
JANUS_GATEWAY_SITE = $(call github,meetecho,janus-gateway,$(JANUS_GATEWAY_VERSION))
JANUS_GATEWAY_LICENSE = GPL-3.0
JANUS_GATEWAY_LICENSE_FILES = COPYING

# ding-libs provides the ini_config library
JANUS_GATEWAY_DEPENDENCIES = host-pkgconf jansson libnice \
	libsrtp host-gengetopt libglib2 openssl

# Straight out of the repository, no ./configure, and we also patch
# configure.ac.
JANUS_GATEWAY_AUTORECONF = YES

define JANUS_GATEWAY_M4
	mkdir -p $(@D)/m4
endef
JANUS_GATEWAY_POST_PATCH_HOOKS += JANUS_GATEWAY_M4

JANUS_GATEWAY_CONF_OPTS = \
	--disable-data-channels \
	--disable-sample-event-handler

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_AUDIO_BRIDGE),y)
JANUS_GATEWAY_DEPENDENCIES += opus
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-audiobridge
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-audiobridge
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_ECHO_TEST),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-echotest
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-echotest
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_RECORDPLAY),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-recordplay
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-recordplay
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_SIP_GATEWAY),y)
JANUS_GATEWAY_DEPENDENCIES += sofia-sip
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-sip
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-sip
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_STREAMING),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-streaming
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-streaming
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_TEXT_ROOM),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-textroom
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-textroom
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_VIDEO_CALL),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-videocall
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-videocall
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_VIDEO_ROOM),y)
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-videoroom
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-videoroom
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_VOICE_MAIL),y)
JANUS_GATEWAY_DEPENDENCIES += libogg
JANUS_GATEWAY_CONF_OPTS += --enable-plugin-voicemail
else
JANUS_GATEWAY_CONF_OPTS += --disable-plugin-voicemail
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_MQTT),y)
JANUS_GATEWAY_DEPENDENCIES += paho-mqtt-c
JANUS_GATEWAY_CONF_OPTS += --enable-mqtt
else
JANUS_GATEWAY_CONF_OPTS += --disable-mqtt
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_RABBITMQ),y)
JANUS_GATEWAY_DEPENDENCIES += rabbitmq-c
JANUS_GATEWAY_CONF_OPTS += --enable-rabbitmq
else
JANUS_GATEWAY_CONF_OPTS += --disable-rabbitmq
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_REST),y)
JANUS_GATEWAY_DEPENDENCIES += libmicrohttpd
JANUS_GATEWAY_CONF_OPTS += --enable-rest
else
JANUS_GATEWAY_CONF_OPTS += --disable-rest
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_UNIX_SOCKETS),y)
JANUS_GATEWAY_CONF_OPTS += --enable-unix-sockets
else
JANUS_GATEWAY_CONF_OPTS += --disable-unix-sockets
endif

ifeq ($(BR2_PACKAGE_JANUS_GATEWAY_WEBSOCKETS),y)
JANUS_GATEWAY_DEPENDENCIES += libwebsockets
JANUS_GATEWAY_CONF_OPTS += --enable-websockets
else
JANUS_GATEWAY_CONF_OPTS += --disable-websockets
endif

# Parallel build broken
JANUS_GATEWAY_MAKE = $(MAKE1)

$(eval $(autotools-package))
