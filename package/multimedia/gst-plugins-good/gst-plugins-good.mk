#############################################################
#
# gst-plugins-good
#
#############################################################
GST_PLUGINS_GOOD_VERSION = 0.10.11
GST_PLUGINS_GOOD_SOURCE = gst-plugins-good-$(GST_PLUGINS_GOOD_VERSION).tar.bz2
GST_PLUGINS_GOOD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-good

GST_PLUGINS_GOOD_CONF_OPT = \
		$(DISABLE_NLS) \
		--disable-examples \
		--disable-directdraw \
		--disable-directsound \
		--disable-sunaudio \
		--disable-osx_audio \
		--disable-osx_video \
		--disable-gst_v4l2 \
		--disable-x \
		--disable-xshm \
		--disable-xvideo \
		--disable-aalibtest \
		--disable-esdtest \
		--disable-shout2 \
		--disable-shout2test

GST_PLUGINS_GOOD_DEPENDENCIES = gstreamer gst-plugins-base

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOFILTER),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-videofilter
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-videofilter
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ALPHA),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-alpha
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-alpha
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_APETAG),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-apetag
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-apetag
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUDIOFX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-audiofx
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-audiofx
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUPARSE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-auparse
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-auparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUTODETECT),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-autodetect
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-autodetect
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AVI),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-avi
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-avi
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_CUTTER),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-cutter
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-cutter
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_DEBUG),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-debug
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-debug
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_EFFECTV),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-effectv
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-effectv
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_EQUALIZER),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-equalizer
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-equalizer
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ID3DEMUX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-id3demux
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-id3demux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ICYDEMUX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-icydemux
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-icydemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_INTERLEAVE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-interleave
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-interleave
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_FLX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-flx
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-flx
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_GOOM),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-goom
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-goom
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_GOOM2K1),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-goom2k1
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-goom2k1
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_LAW),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-law
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-law
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_LEVEL),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-level
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-level
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MATROSKA),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-matroska
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-matroska
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MONOSCOPE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-monoscope
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-monoscope
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MULTIFILE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-multifile
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-multifile
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MULTIPART),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-multipart
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-multipart
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_QTDEMUX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-qtdemux
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-qtdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_REPLAYGAIN),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-replaygain
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-replaygain
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_RTP),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-rtp
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-rtp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_RTSP),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-rtsp
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-rtsp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SMPTE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-smpte
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-smpte
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SPECTRUM),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-spectrum
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-spectrum
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_UDP),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-udp
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-udp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOBOX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-videobox
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-videobox
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOCROP),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-videocrop
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-videocrop
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOMIXER),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-videomixer
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-videomixer
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_WAVENC),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-wavenc
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-wavenc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_WAVPARSE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-wavparse
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-wavparse
endif

$(eval $(call AUTOTARGETS,package/multimedia,gst-plugins-good))
