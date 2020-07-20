################################################################################
#
# freerdp
#
################################################################################

FREERDP_VERSION = 2.2.0
FREERDP_SITE = https://pub.freerdp.com/releases
FREERDP_DEPENDENCIES = libglib2 openssl zlib
FREERDP_LICENSE = Apache-2.0
FREERDP_LICENSE_FILES = LICENSE

FREERDP_INSTALL_STAGING = YES

FREERDP_CONF_OPTS = -DWITH_MANPAGES=OFF -Wno-dev -DWITH_GSTREAMER_0_10=OFF

ifeq ($(BR2_PACKAGE_FREERDP_GSTREAMER1),y)
FREERDP_CONF_OPTS += -DWITH_GSTREAMER_1_0=ON
FREERDP_DEPENDENCIES += gstreamer1 gst1-plugins-base
else
FREERDP_CONF_OPTS += -DWITH_GSTREAMER_1_0=OFF
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

ifeq ($(BR2_PACKAGE_LIBUSB),y)
FREERDP_CONF_OPTS += -DCHANNEL_URBDRC=ON
FREERDP_DEPENDENCIES += libusb
else
FREERDP_CONF_OPTS += -DCHANNEL_URBDRC=OFF
endif

ifeq ($(BR2_PACKAGE_PULSEAUDIO),y)
FREERDP_CONF_OPTS += -DWITH_PULSE=ON
FREERDP_DEPENDENCIES += pulseaudio
else
FREERDP_CONF_OPTS += -DWITH_PULSE=OFF
endif

# For the systemd journal
ifeq ($(BR2_PACKAGE_SYSTEMD),y)
FREERDP_CONF_OPTS += -DWITH_LIBSYSTEMD=ON
FREERDP_DEPENDENCIES += systemd
else
FREERDP_CONF_OPTS += -DWITH_LIBSYSTEMD=OFF
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
FREERDP_CONF_OPTS += -DARM_FP_ABI=$(GCC_TARGET_FLOAT_ABI)
endif

#---------------------------------------
# Enabling server and/or client

# Clients and server interface must always be enabled to build the
# corresponding libraries.
FREERDP_CONF_OPTS += -DWITH_SERVER_INTERFACE=ON
FREERDP_CONF_OPTS += -DWITH_CLIENT_INTERFACE=ON

ifeq ($(BR2_PACKAGE_FREERDP_SERVER),y)
FREERDP_CONF_OPTS += -DWITH_SERVER=ON
endif

ifneq ($(BR2_PACKAGE_FREERDP_CLIENT_X11)$(BR2_PACKAGE_FREERDP_CLIENT_WL),)
FREERDP_CONF_OPTS += -DWITH_CLIENT=ON
endif

#---------------------------------------
# Libraries for client and/or server

# The FreeRDP buildsystem uses non-orthogonal options. For example it
# is not possible to build the server and the wayland client without
# also building the X client. That's because the dependencies of the
# server (the X libraries) are a superset of those of the X client.
# So, as soon as FreeRDP is configured for the server and the wayland
# client, it will believe it also has to build the X client, because
# the libraries it needs are enabled.
#
# Furthermore, the shadow server is always built, even if there's nothing
# it can serve (i.e. the X libs are disabled).
#
# So, we do not care whether we build too much; we remove, as
# post-install hooks, whatever we do not want.

# If Xorg is enabled, and the server or the X client are, then libX11
# and libXext are forcibly enabled at the Kconfig level. However, if
# Xorg is enabled but neither the server nor the X client are, then
# there's nothing that guarantees those two libs are enabled. So we
# really must check for them.
ifeq ($(BR2_PACKAGE_XLIB_LIBX11)$(BR2_PACKAGE_XLIB_LIBXEXT),yy)
FREERDP_DEPENDENCIES += xlib_libX11 xlib_libXext
FREERDP_CONF_OPTS += -DWITH_X11=ON
else
FREERDP_CONF_OPTS += -DWITH_X11=OFF
endif

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

ifeq ($(BR2_PACKAGE_FREERDP_CLIENT_WL),y)
FREERDP_DEPENDENCIES += wayland libxkbcommon
FREERDP_CONF_OPTS += \
	-DWITH_WAYLAND=ON \
	-DWAYLAND_SCANNER=$(HOST_DIR)/bin/wayland-scanner
else
FREERDP_CONF_OPTS += -DWITH_WAYLAND=OFF
endif

#---------------------------------------
# Post-install hooks to cleanup and install missing stuff

# Shadow server is always installed, no matter what, so we manually
# remove it if the user does not want the server.
ifeq ($(BR2_PACKAGE_FREERDP_SERVER),)
define FREERDP_RM_SHADOW_SERVER
	rm -f $(TARGET_DIR)/usr/bin/freerdp-shadow
endef
FREERDP_POST_INSTALL_TARGET_HOOKS += FREERDP_RM_SHADOW_SERVER
endif # ! server

# X client is always built as soon as a client is enabled and the
# necessary libs are enabled (e.g. because of the server), so manually
# remove it if the user does not want it.
ifeq ($(BR2_PACKAGE_FREERDP_CLIENT_X11),)
define FREERDP_RM_CLIENT_X11
	rm -f $(TARGET_DIR)/usr/bin/xfreerdp
	rm -f $(TARGET_DIR)/usr/lib/libxfreerdp-client*
endef
FREERDP_POST_INSTALL_TARGET_HOOKS += FREERDP_RM_CLIENT_X11
define FREERDP_RM_CLIENT_X11_LIB
	rm -f $(STAGING_DIR)/usr/lib/libxfreerdp-client*
endef
FREERDP_POST_INSTALL_STAGING_HOOKS += FREERDP_RM_CLIENT_X11_LIB
endif # ! X client

# Wayland client is always built as soon as wayland is enabled, so
# manually remove it if the user does not want it.
ifeq ($(BR2_PACKAGE_FREERDP_CLIENT_WL),)
define FREERDP_RM_CLIENT_WL
	rm -f $(TARGET_DIR)/usr/bin/wlfreerdp
endef
FREERDP_POST_INSTALL_TARGET_HOOKS += FREERDP_RM_CLIENT_WL
endif

# Remove static libraries in unusual dir
define FREERDP_CLEANUP
	rm -rf $(TARGET_DIR)/usr/lib/freerdp
endef
FREERDP_POST_INSTALL_TARGET_HOOKS += FREERDP_CLEANUP

# Install the server key and certificate, so that a client can connect.
# A user can override them with its own in a post-build script, if needed.
# We install them even if the server is not enabled, since another server
# can be built and linked with libfreerdp (e.g. weston with the  RDP
# backend). Key and cert are installed world-readable, so non-root users
# can start a server.
define FREERDP_INSTALL_KEYS
	$(INSTALL) -m 0644 -D $(@D)/server/Sample/server.key \
		$(TARGET_DIR)/etc/freerdp/keys/server.key
	$(INSTALL) -m 0644 -D $(@D)/server/Sample/server.crt \
		$(TARGET_DIR)/etc/freerdp/keys/server.crt
endef
FREERDP_POST_INSTALL_TARGET_HOOKS += FREERDP_INSTALL_KEYS

$(eval $(cmake-package))
