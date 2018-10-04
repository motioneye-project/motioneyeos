################################################################################
#
# gst1-plugins-base
#
################################################################################

GST1_PLUGINS_BASE_VERSION = 1.14.4
GST1_PLUGINS_BASE_SOURCE = gst-plugins-base-$(GST1_PLUGINS_BASE_VERSION).tar.xz
GST1_PLUGINS_BASE_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-base
GST1_PLUGINS_BASE_INSTALL_STAGING = YES
GST1_PLUGINS_BASE_LICENSE_FILES = COPYING.LIB
GST1_PLUGINS_BASE_LICENSE = LGPL-2.0+, LGPL-2.1+

# gio_unix_2_0 is only used for tests
GST1_PLUGINS_BASE_CONF_OPTS = \
	--disable-examples \
	--disable-valgrind \
	--disable-introspection

# Options which require currently unpackaged libraries
GST1_PLUGINS_BASE_CONF_OPTS += \
	--disable-cdparanoia \
	--disable-libvisual \
	--disable-iso-codes

GST1_PLUGINS_BASE_DEPENDENCIES = gstreamer1

# These plugins are listed in the order from ./configure --help
ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_BASE_DEPENDENCIES += orc
GST1_PLUGINS_BASE_CONF_OPTS += --enable-orc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_OPENGL),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-opengl
GST1_PLUGINS_BASE_DEPENDENCIES += libgl libglu
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-opengl
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_GLES2),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-gles2
GST1_PLUGINS_BASE_DEPENDENCIES += libgles
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-gles2
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_GLX),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-glx
GST1_PLUGINS_BASE_DEPENDENCIES += xorgproto xlib_libXrender
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-glx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_EGL),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-egl
GST1_PLUGINS_BASE_DEPENDENCIES += libegl
GST1_PLUGINS_BASE_CONF_ENV += \
	CPPFLAGS="$(TARGET_CPPFLAGS) `$(PKG_CONFIG_HOST_BINARY) --cflags egl`" \
	LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs egl`"
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-egl
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_X11),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-x11
GST1_PLUGINS_BASE_DEPENDENCIES += xlib_libX11 xlib_libXext
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-x11
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_WAYLAND),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-wayland
GST1_PLUGINS_BASE_DEPENDENCIES += wayland wayland-protocols
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-wayland
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_LIB_OPENGL_DISPMANX),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-dispmanx
GST1_PLUGINS_BASE_DEPENDENCIES += rpi-userland
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-dispmanx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_ADDER),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-adder
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-adder
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_APP),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-app
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-app
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIOCONVERT),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-audioconvert
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-audioconvert
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIOMIXER),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-audiomixer
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-audiomixer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIORATE),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-audiorate
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-audiorate
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIOTESTSRC),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-audiotestsrc
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-audiotestsrc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_ENCODING),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-encoding
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-encoding
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEOCONVERT),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-videoconvert
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-videoconvert
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_GIO),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-gio
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-gio
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_PLAYBACK),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-playback
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-playback
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_AUDIORESAMPLE),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-audioresample
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-audioresample
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_RAWPARSE),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-rawparse
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-rawparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_SUBPARSE),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-subparse
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-subparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_TCP),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-tcp
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-tcp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_TYPEFIND),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-typefind
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-typefind
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEOTESTSRC),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-videotestsrc
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-videotestsrc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEORATE),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-videorate
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-videorate
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VIDEOSCALE),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-videoscale
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-videoscale
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VOLUME),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-volume
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-volume
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GST1_PLUGINS_BASE_DEPENDENCIES += zlib
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
GST1_PLUGINS_BASE_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
GST1_PLUGINS_BASE_CONF_OPTS += \
	--enable-x \
	--enable-xshm \
	--enable-xvideo
else
GST1_PLUGINS_BASE_CONF_OPTS += \
	--disable-x \
	--disable-xshm \
	--disable-xvideo
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_ALSA),y)
GST1_PLUGINS_BASE_DEPENDENCIES += alsa-lib
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_TREMOR),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-ivorbis
GST1_PLUGINS_BASE_DEPENDENCIES += tremor
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-ivorbis
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_OPUS),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-opus
GST1_PLUGINS_BASE_DEPENDENCIES += opus
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_OGG),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-ogg
GST1_PLUGINS_BASE_DEPENDENCIES += libogg
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-ogg
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_PANGO),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-pango
GST1_PLUGINS_BASE_DEPENDENCIES += pango
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-pango
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_THEORA),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-theora
GST1_PLUGINS_BASE_DEPENDENCIES += libtheora
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-theora
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE_PLUGIN_VORBIS),y)
GST1_PLUGINS_BASE_CONF_OPTS += --enable-vorbis
GST1_PLUGINS_BASE_DEPENDENCIES += libvorbis
else
GST1_PLUGINS_BASE_CONF_OPTS += --disable-vorbis
endif

$(eval $(autotools-package))
