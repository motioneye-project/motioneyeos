################################################################################
#
# freerdp
#
################################################################################

# Changeset on the stable-1.1 branch
FREERDP_VERSION = b21ff842ef3de5837513042dc30488b12bd9cf9d
FREERDP_SITE = $(call github,FreeRDP,FreeRDP,$(FREERDP_VERSION))
FREERDP_DEPENDENCIES = openssl zlib
FREERDP_LICENSE = Apache-2.0
FREERDP_LICENSE_FILES = LICENSE

FREERDP_INSTALL_STAGING = YES

FREERDP_CONF_OPTS = -DWITH_MANPAGES=OFF -Wno-dev

ifeq ($(BR2_PACKAGE_GSTREAMER),y)
FREERDP_CONF_OPTS += -DWITH_GSTREAMER=ON
FREERDP_DEPENDENCIES += gstreamer
else
FREERDP_CONF_OPTS += -DWITH_GSTREAMER=OFF
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
FREERDP_CONF_OPTS += -DWITH_CUPS=ON
FREERDP_DEPENDENCIES += cups
else
FREERDP_CONF_OPTS += -DWITH_CUPS=OFF
endif

ifeq ($(BR2_PACKAGE_FFMPEG),y)
FREERDP_CONF_OPTS += -DWITH_FFMPEG=ON
FREERDP_DEPENDENCIES += ffmpeg
else
FREERDP_CONF_OPTS += -DWITH_FFMPEG=OFF
endif

ifeq ($(BR2_PACKAGE_ALSA_LIB_MIXER),y)
FREERDP_CONF_OPTS += -DWITH_ALSA=ON
FREERDP_DEPENDENCIES += alsa-lib
else
FREERDP_CONF_OPTS += -DWITH_ALSA=OFF
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
FREERDP_CONF_OPTS += -DWITH_PULSEAUDIO=ON
FREERDP_DEPENDENCIES += pulseaudio
else
FREERDP_CONF_OPTS += -DWITH_PULSEAUDIO=OFF
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),y)
FREERDP_CONF_OPTS += -DWITH_NEON=ON
else
FREERDP_CONF_OPTS += -DWITH_NEON=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
FREERDP_CONF_OPTS += -DWITH_SSE2=ON
else
FREERDP_CONF_OPTS += -DWITH_SSE2=OFF
endif

ifeq ($(BR2_arm)$(BR2_armeb),y)
FREERDP_CONF_OPTS += -DARM_FP_ABI=$(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
endif

#---------------------------------------
# Enabling server and/or client

ifeq ($(BR2_PACKAGE_FREERDP_SERVER),y)
FREERDP_CONF_OPTS += -DWITH_SERVER=ON -DWITH_SERVER_INTERFACE=ON
else
FREERDP_CONF_OPTS += -DWITH_SERVER=OFF -DWITH_SERVER_INTERFACE=OFF
endif

ifeq ($(BR2_PACKAGE_FREERDP_CLIENT),y)
FREERDP_CONF_OPTS += -DWITH_CLIENT=ON -DWITH_CLIENT_INTERFACE=ON
else
FREERDP_CONF_OPTS += -DWITH_CLIENT=OFF -DWITH_CLIENT_INTERFACE=OFF
endif

#---------------------------------------
# X.Org libs for client and/or server

ifneq ($(BR2_PACKAGE_FREERDP_SERVER)$(BR2_PACKAGE_FREERDP_CLIENT),)

# Those two are mandatory for both the server and the client
FREERDP_DEPENDENCIES += xlib_libX11 xlib_libXext
FREERDP_CONF_OPTS += -DWITH_X11=ON

# The following libs are either optional or mandatory only for either
# the server or the client. A mandatory library for either one is
# selected from Kconfig, so we can make it conditional here
ifeq ($(BR2_PACKAGE_XLIB_LIBXCURSOR),y)
FREERDP_CONF_OPTS += -DWITH_XCURSOR=ON
FREERDP_DEPENDENCIES += xlib_libXcursor
else
FREERDP_CONF_OPTS += -DWITH_XCURSOR=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXDAMAGE),y)
FREERDP_CONF_OPTS += -DWITH_XDAMAGE=ON
FREERDP_DEPENDENCIES += xlib_libXdamage
else
FREERDP_CONF_OPTS += -DWITH_XDAMAGE=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXFIXES),y)
FREERDP_CONF_OPTS += -DWITH_XFIXES=ON
FREERDP_DEPENDENCIES += xlib_libXfixes
else
FREERDP_CONF_OPTS += -DWITH_XFIXES=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
FREERDP_CONF_OPTS += -DWITH_XI=ON
FREERDP_DEPENDENCIES += xlib_libXi
else
FREERDP_CONF_OPTS += -DWITH_XI=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXINERAMA),y)
FREERDP_CONF_OPTS += -DWITH_XINERAMA=ON
FREERDP_DEPENDENCIES += xlib_libXinerama
else
FREERDP_CONF_OPTS += -DWITH_XINERAMA=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXKBFILE),y)
FREERDP_CONF_OPTS += -DWITH_XKBFILE=ON
FREERDP_DEPENDENCIES += xlib_libxkbfile
else
FREERDP_CONF_OPTS += -DWITH_XKBFILE=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRANDR),y)
FREERDP_CONF_OPTS += -DWITH_XRANDR=ON
FREERDP_DEPENDENCIES += xlib_libXrandr
else
FREERDP_CONF_OPTS += -DWITH_XRANDR=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXRENDER),y)
FREERDP_CONF_OPTS += -DWITH_XRENDER=ON
FREERDP_DEPENDENCIES += xlib_libXrender
else
FREERDP_CONF_OPTS += -DWITH_XRENDER=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXTST),y)
FREERDP_CONF_OPTS += -DWITH_XTEST=ON
FREERDP_DEPENDENCIES += xlib_libXtst
else
FREERDP_CONF_OPTS += -DWITH_XTEST=OFF
endif

ifeq ($(BR2_PACKAGE_XLIB_LIBXV),y)
FREERDP_CONF_OPTS += -DWITH_XV=ON
FREERDP_DEPENDENCIES += xlib_libXv
else
FREERDP_CONF_OPTS += -DWITH_XV=OFF
endif

else # ! SERVER && ! CLIENT

FREERDP_CONF_OPTS += -DWITH_X11=OFF

endif # ! SERVER && ! CLIENT

# Install the server key and certificate, so that a client can connect.
# A user can override them with its own in a post-build script, if needed.
# We install them even if the server is not enabled, since another server
# can be built and linked with libfreerdp (e.g. weston with the  RDP
# backend). Key and cert are installed world-readable, so non-root users
# can start a server.
define FREERDP_INSTALL_KEYS
	$(INSTALL) -m 0644 -D $(@D)/server/X11/server.key \
		      $(TARGET_DIR)/etc/freerdp/keys/server.key
	$(INSTALL) -m 0644 -D $(@D)/server/X11/server.crt \
		      $(TARGET_DIR)/etc/freerdp/keys/server.crt
endef
FREERDP_POST_INSTALL_TARGET_HOOKS += FREERDP_INSTALL_KEYS

$(eval $(cmake-package))
