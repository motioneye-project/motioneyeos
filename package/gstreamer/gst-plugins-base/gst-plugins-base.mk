################################################################################
#
# gst-plugins-base
#
################################################################################

GST_PLUGINS_BASE_VERSION = 0.10.36
GST_PLUGINS_BASE_SOURCE = gst-plugins-base-$(GST_PLUGINS_BASE_VERSION).tar.xz
GST_PLUGINS_BASE_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-base
GST_PLUGINS_BASE_INSTALL_STAGING = YES

# freetype is only used by examples, but if it is not found
# and the host has a freetype-config script, then the host
# include dirs are added to the search path causing trouble
GST_PLUGINS_BASE_CONF_ENV =
		FT2_CONFIG=/bin/false \
		ac_cv_header_stdint_t="stdint.h"

GST_PLUGINS_BASE_CONF_OPTS = \
	--disable-examples \
	--disable-oggtest \
	--disable-vorbistest \
	--disable-freetypetest

GST_PLUGINS_BASE_DEPENDENCIES = gstreamer

ifeq ($(BR2_PACKAGE_XORG7),y)
GST_PLUGINS_BASE_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
GST_PLUGINS_BASE_CONF_OPTS += \
	--enable-x \
	--enable-xshm \
	--enable-xvideo
else
GST_PLUGINS_BASE_CONF_OPTS += \
	--disable-x \
	--disable-xshm \
	--disable-xvideo
endif

ifeq ($(BR2_PACKAGE_ORC),y)
GST_PLUGINS_BASE_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_ALSA),y)
GST_PLUGINS_BASE_DEPENDENCIES += alsa-lib
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_ADDER),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-adder
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-adder
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_APP),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-app
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-app
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIOCONVERT),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-audioconvert
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-audioconvert
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIORATE),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-audiorate
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-audiorate
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIORESAMPLE),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-audioresample
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-audioresample
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIOTESTSRC),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-audiotestsrc
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-audiotestsrc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_ENCODING),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-encoding
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-encoding
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_FFMPEGCOLORSPACE),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-ffmpegcolorspace
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-ffmpegcolorspace
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_GDP),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-gdp
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-gdp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_PLAYBACK),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-playback
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-playback
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_SUBPARSE),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-subparse
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-subparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_TCP),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-tcp
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-tcp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_TYPEFIND),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-typefind
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-typefind
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VIDEOTESTSRC),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-videotestsrc
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-videotestsrc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VIDEORATE),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-videorate
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-videorate
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VIDEOSCALE),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-videoscale
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-videoscale
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VOLUME),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-volume
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-volume
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_OGG),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-ogg
GST_PLUGINS_BASE_DEPENDENCIES += libogg
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-ogg
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_PANGO),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-pango
GST_PLUGINS_BASE_DEPENDENCIES += pango
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-pango
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_THEORA),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-theora
GST_PLUGINS_BASE_DEPENDENCIES += libtheora
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-theora
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_TREMOR),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-ivorbis
GST_PLUGINS_BASE_DEPENDENCIES += tremor
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-ivorbis
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VORBIS),y)
GST_PLUGINS_BASE_CONF_OPTS += --enable-vorbis
GST_PLUGINS_BASE_DEPENDENCIES += libvorbis
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-vorbis
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
GST_PLUGINS_BASE_DEPENDENCIES += zlib
else
GST_PLUGINS_BASE_CONF_OPTS += --disable-zlib
endif

$(eval $(autotools-package))
