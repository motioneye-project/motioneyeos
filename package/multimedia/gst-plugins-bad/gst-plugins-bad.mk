#############################################################
#
# gst-plugins-bad
#
#############################################################
GST_PLUGINS_BAD_VERSION = 0.10.12
GST_PLUGINS_BAD_SOURCE = gst-plugins-bad-$(GST_PLUGINS_BAD_VERSION).tar.bz2
GST_PLUGINS_BAD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-bad
GST_PLUGINS_BAD_LIBTOOL_PATCH = NO

GST_PLUGINS_BAD_CONF_OPT = \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--disable-examples

GST_PLUGINS_BAD_DEPENDENCIES = gst-plugins-base gstreamer liboil

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AACPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-aacparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-aacparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AIFFPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-aiffparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-aiffparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AMRPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-amrparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-amrparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AUTOCONVERT),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-autoconvert
else
GST_PLUGINS_BAD_CONF_OPT += --disable-autoconvert
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CAMERABIN),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-camerabin
else
GST_PLUGINS_BAD_CONF_OPT += --disable-camerabin
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LEGACYRESAMPLE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-legacyresample
else
GST_PLUGINS_BAD_CONF_OPT += --disable-legacyresample
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_BAYER),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-bayer
else
GST_PLUGINS_BAD_CONF_OPT += --disable-bayer
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CDXAPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-cdxaparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-cdxaparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DCCP),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dccp
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dccp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DEBUGUTILS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-debugutils
else
GST_PLUGINS_BAD_CONF_OPT += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DTMF),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dtmf
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dtmf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DVDSPU),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dvdspu
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dvdspu
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FESTIVAL),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-festival
else
GST_PLUGINS_BAD_CONF_OPT += --disable-festival
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FREEZE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-freeze
else
GST_PLUGINS_BAD_CONF_OPT += --disable-freeze
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_H264PARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-h264parse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-h264parse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LIBRFB),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-librfb
else
GST_PLUGINS_BAD_CONF_OPT += --disable-librfb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LIVEADDER),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-liveadder
else
GST_PLUGINS_BAD_CONF_OPT += --disable-liveadder
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGDEMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mpegdemux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mpegdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGTSMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mpegtsmux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mpegtsmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEG4VIDEOPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mpeg4videoparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mpeg4videoparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGVIDEOPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mpegvideoparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mpegvideoparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MVE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mve
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mve
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MXF),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mxf
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mxf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_NSF),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-nsf
else
GST_PLUGINS_BAD_CONF_OPT += --disable-nsf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_NUVDEMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-nuvdemux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-nuvdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_PCAPPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-pcapparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-pcapparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_QTMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-qtmux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-qtmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RAWPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-rawparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-rawparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_REAL),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-real
else
GST_PLUGINS_BAD_CONF_OPT += --disable-real
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RTPMANAGER),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-rtpmanager
else
GST_PLUGINS_BAD_CONF_OPT += --disable-rtpmanager
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RTPMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-rtpmux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-rtpmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SCALETEMPO),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-scaletempo
else
GST_PLUGINS_BAD_CONF_OPT += --disable-scaletempo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDP),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-sdp
else
GST_PLUGINS_BAD_CONF_OPT += --disable-sdp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SELECTOR),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-selector
else
GST_PLUGINS_BAD_CONF_OPT += --disable-selector
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SIREN),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-siren
else
GST_PLUGINS_BAD_CONF_OPT += --disable-siren
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SPEED),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-speed
else
GST_PLUGINS_BAD_CONF_OPT += --disable-speed
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SUBENC),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-subenc
else
GST_PLUGINS_BAD_CONF_OPT += --disable-subenc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_STEREO),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-stereo
else
GST_PLUGINS_BAD_CONF_OPT += --disable-stereo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_TTA),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-tta
else
GST_PLUGINS_BAD_CONF_OPT += --disable-tta
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VALVE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-valve
else
GST_PLUGINS_BAD_CONF_OPT += --disable-valve
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOSIGNAL),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-videosignal
else
GST_PLUGINS_BAD_CONF_OPT += --disable-videosignal
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VMNC),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-vmnc
else
GST_PLUGINS_BAD_CONF_OPT += --disable-vmnc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_XDGMIME),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-xdgmime
else
GST_PLUGINS_BAD_CONF_OPT += --disable-xdgmime
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DIRECTFB),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-directfb
GST_PLUGINS_BAD_DEPENDENCIES += directfb
else
GST_PLUGINS_BAD_CONF_OPT += --disable-directfb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DVB),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dvb
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dvb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FBDEV),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-fbdev
else
GST_PLUGINS_BAD_CONF_OPT += --disable-fbdev
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_NEON),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-neon
GST_PLUGINS_BAD_DEPENDENCIES += neon
else
GST_PLUGINS_BAD_CONF_OPT += --disable-neon
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_OSS4),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-oss4
else
GST_PLUGINS_BAD_CONF_OPT += --disable-oss4
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDL),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-sdl
GST_PLUGINS_BAD_DEPENDENCIES += sdl
else
GST_PLUGINS_BAD_CONF_OPT += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VCD),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-vcd
else
GST_PLUGINS_BAD_CONF_OPT += --disable-vcd
endif

$(eval $(call AUTOTARGETS,package/multimedia,gst-plugins-bad))
