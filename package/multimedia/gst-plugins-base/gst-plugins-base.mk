#############################################################
#
# gst-plugins-base
#
#############################################################
GST_PLUGINS_BASE_VERSION = 0.10.32
GST_PLUGINS_BASE_SOURCE = gst-plugins-base-$(GST_PLUGINS_BASE_VERSION).tar.bz2
GST_PLUGINS_BASE_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-base
GST_PLUGINS_BASE_INSTALL_STAGING = YES

# freetype is only used by examples, but if it is not found
# and the host has a freetype-config script, then the host
# include dirs are added to the search path causing trouble
GST_PLUGINS_BASE_CONF_ENV =
		FT2_CONFIG=/bin/false \
		ac_cv_header_stdint_t="stdint.h"

GST_PLUGINS_BASE_CONF_OPT = \
		--disable-examples \
		--disable-x \
		--disable-xvideo \
		--disable-xshm \
		--disable-oggtest \
		--disable-vorbistest \
		--disable-freetypetest

GST_PLUGINS_BASE_DEPENDENCIES = gstreamer

# alsa support needs pcm+mixer support, but configure fails to check for it
ifeq ($(BR2_PACKAGE_ALSA_LIB)$(BR2_PACKAGE_ALSA_LIB_MIXER)$(BR2_PACKAGE_ALSA_LIB_PCM),yyy)
GST_PLUGINS_BASE_DEPENDENCIES += alsa-lib
else
GST_PLUGINS_BASE_CONF_OPT += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_ADDER),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-adder
else
GST_PLUGINS_BASE_CONF_OPT += --disable-adder
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_APP),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-app
else
GST_PLUGINS_BASE_CONF_OPT += --disable-app
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIOCONVERT),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-audioconvert
else
GST_PLUGINS_BASE_CONF_OPT += --disable-audioconvert
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIORATE),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-audiorate
else
GST_PLUGINS_BASE_CONF_OPT += --disable-audiorate
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIORESAMPLE),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-audioresample
else
GST_PLUGINS_BASE_CONF_OPT += --disable-audioresample
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_AUDIOTESTSRC),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-audiotestsrc
else
GST_PLUGINS_BASE_CONF_OPT += --disable-audiotestsrc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_FFMPEGCOLORSPACE),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-ffmpegcolorspace
else
GST_PLUGINS_BASE_CONF_OPT += --disable-ffmpegcolorspace
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_GDP),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-gdp
else
GST_PLUGINS_BASE_CONF_OPT += --disable-gdp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_PLAYBACK),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-playback
else
GST_PLUGINS_BASE_CONF_OPT += --disable-playback
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_SUBPARSE),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-subparse
else
GST_PLUGINS_BASE_CONF_OPT += --disable-subparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_TCP),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-tcp
else
GST_PLUGINS_BASE_CONF_OPT += --disable-tcp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_TYPEFIND),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-typefind
else
GST_PLUGINS_BASE_CONF_OPT += --disable-typefind
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VIDEOTESTSRC),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-videotestsrc
else
GST_PLUGINS_BASE_CONF_OPT += --disable-videotestsrc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VIDEORATE),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-videorate
else
GST_PLUGINS_BASE_CONF_OPT += --disable-videorate
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VIDEOSCALE),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-videoscale
else
GST_PLUGINS_BASE_CONF_OPT += --disable-videoscale
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VOLUME),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-volume
else
GST_PLUGINS_BASE_CONF_OPT += --disable-volume
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_OGG),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-ogg
GST_PLUGINS_BASE_DEPENDENCIES += libogg
else
GST_PLUGINS_BASE_CONF_OPT += --disable-ogg
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_PANGO),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-pango
GST_PLUGINS_BASE_DEPENDENCIES += pango
else
GST_PLUGINS_BASE_CONF_OPT += --disable-pango
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_THEORA),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-theora
GST_PLUGINS_BASE_DEPENDENCIES += libtheora
else
GST_PLUGINS_BASE_CONF_OPT += --disable-theora
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE_PLUGIN_VORBIS),y)
GST_PLUGINS_BASE_CONF_OPT += --enable-vorbis
GST_PLUGINS_BASE_DEPENDENCIES += libvorbis
else
GST_PLUGINS_BASE_CONF_OPT += --disable-vorbis
endif

$(eval $(call AUTOTARGETS,package/multimedia,gst-plugins-base))
