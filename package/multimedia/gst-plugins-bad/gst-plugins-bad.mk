#############################################################
#
# gst-plugins-bad
#
#############################################################
GST_PLUGINS_BAD_VERSION = 0.10.23
GST_PLUGINS_BAD_SOURCE = gst-plugins-bad-$(GST_PLUGINS_BAD_VERSION).tar.bz2
GST_PLUGINS_BAD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-bad

GST_PLUGINS_BAD_CONF_OPT = \
		--disable-examples

GST_PLUGINS_BAD_DEPENDENCIES = gst-plugins-base gstreamer

ifeq ($(BR2_PACKAGE_ORC),y)
GST_PLUGINS_BAD_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ADPCMDEC),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-adpcmdec
else
GST_PLUGINS_BAD_CONF_OPT += --disable-adpcmdec
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ADPCMENC),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-adpcmenc
else
GST_PLUGINS_BAD_CONF_OPT += --disable-adpcmenc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AIFF),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-aiff
else
GST_PLUGINS_BAD_CONF_OPT += --disable-aiff
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ASFMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-asfmux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-asfmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AUDIOVISUALIZERS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-audiovisualizers
else
GST_PLUGINS_BAD_CONF_OPT += --disable-audiovisualizers
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AUTOCONVERT),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-autoconvert
else
GST_PLUGINS_BAD_CONF_OPT += --disable-autoconvert
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_BAYER),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-bayer
else
GST_PLUGINS_BAD_CONF_OPT += --disable-bayer
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CAMERABIN),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-camerabin
else
GST_PLUGINS_BAD_CONF_OPT += --disable-camerabin
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CAMERABIN2),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-camerabin2
else
GST_PLUGINS_BAD_CONF_OPT += --disable-camerabin2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CDXAPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-cdxaparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-cdxaparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_COLOREFFECTS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-coloreffects
else
GST_PLUGINS_BAD_CONF_OPT += --disable-coloreffects
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_COLORSPACE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-colorspace
else
GST_PLUGINS_BAD_CONF_OPT += --disable-colorspace
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DATAURISRC),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dataurisrc
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dataurisrc
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DECKLINK),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-decklink
else
GST_PLUGINS_BAD_CONF_OPT += --disable-decklink
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DTMF),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dtmf
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dtmf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DVBSUBOVERLAY),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dvbsuboverlay
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dvbsuboverlay
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DVDSPU),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-dvdspu
else
GST_PLUGINS_BAD_CONF_OPT += --disable-dvdspu
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FACEOVERLAY),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-faceoverlay
else
GST_PLUGINS_BAD_CONF_OPT += --disable-faceoverlay
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FESTIVAL),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-festival
else
GST_PLUGINS_BAD_CONF_OPT += --disable-festival
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FIELDANALYSIS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-fieldanalysis
else
GST_PLUGINS_BAD_CONF_OPT += --disable-fieldanalysis
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FREEZE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-freeze
else
GST_PLUGINS_BAD_CONF_OPT += --disable-freeze
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FREEVERB),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-freeverb
else
GST_PLUGINS_BAD_CONF_OPT += --disable-freeverb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FREI0R),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-frei0r
else
GST_PLUGINS_BAD_CONF_OPT += --disable-frei0r
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_GAUDIEFFECTS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-gaudieffects
else
GST_PLUGINS_BAD_CONF_OPT += --disable-gaudieffects
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_GEOMETRICTRANSFORM),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-geometrictransform
else
GST_PLUGINS_BAD_CONF_OPT += --disable-geometrictransform
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_GSETTINGS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-gsettings
else
GST_PLUGINS_BAD_CONF_OPT += --disable-gsettings
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_H264PARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-h264parse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-h264parse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_HDVPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-hdvparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-hdvparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_HLS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-hls
else
GST_PLUGINS_BAD_CONF_OPT += --disable-hls
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ID3TAG),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-id3tag
else
GST_PLUGINS_BAD_CONF_OPT += --disable-id3tag
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_INTER),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-inter
else
GST_PLUGINS_BAD_CONF_OPT += --disable-inter
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_INTERLACE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-interlace
else
GST_PLUGINS_BAD_CONF_OPT += --disable-interlace
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_IVFPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-ivfparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-ivfparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_JP2KDECIMATOR),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-jp2kdecimator
else
GST_PLUGINS_BAD_CONF_OPT += --disable-jp2kdecimator
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_JPEGFORMAT),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-jpegformat
else
GST_PLUGINS_BAD_CONF_OPT += --disable-jpegformat
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LEGACYRESAMPLE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-legacyresample
else
GST_PLUGINS_BAD_CONF_OPT += --disable-legacyresample
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LIBRFB),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-librfb
else
GST_PLUGINS_BAD_CONF_OPT += --disable-librfb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LINSYS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-linsys
else
GST_PLUGINS_BAD_CONF_OPT += --disable-linsys
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGPSMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mpegpsmux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mpegpsmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGTSDEMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mpegtsdemux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mpegtsdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGTSMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-mpegtsmux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-mpegtsmux
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_PATCHDETECT),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-patchdetect
else
GST_PLUGINS_BAD_CONF_OPT += --disable-patchdetect
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_PCAPPARSE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-pcapparse
else
GST_PLUGINS_BAD_CONF_OPT += --disable-pcapparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_PNM),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-pnm
else
GST_PLUGINS_BAD_CONF_OPT += --disable-pnm
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_REMOVESILENCE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-removesilence
else
GST_PLUGINS_BAD_CONF_OPT += --disable-removesilence
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RTPMUX),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-rtpmux
else
GST_PLUGINS_BAD_CONF_OPT += --disable-rtpmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RTPVP8),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-rtpvp8
else
GST_PLUGINS_BAD_CONF_OPT += --disable-rtpvp8
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SCALETEMPO),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-scaletempo
else
GST_PLUGINS_BAD_CONF_OPT += --disable-scaletempo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDI),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-sdi
else
GST_PLUGINS_BAD_CONF_OPT += --disable-sdi
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDP),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-sdp
else
GST_PLUGINS_BAD_CONF_OPT += --disable-sdp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SEGMENTCLIP),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-segmentclip
else
GST_PLUGINS_BAD_CONF_OPT += --disable-segmentclip
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SIREN),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-siren
else
GST_PLUGINS_BAD_CONF_OPT += --disable-siren
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SMOOTH),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-smooth
else
GST_PLUGINS_BAD_CONF_OPT += --disable-smooth
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOFILTERS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-videofilters
else
GST_PLUGINS_BAD_CONF_OPT += --disable-videofilters
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOMAXRATE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-videomaxrate
else
GST_PLUGINS_BAD_CONF_OPT += --disable-videomaxrate
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOMEASURE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-videomeasure
else
GST_PLUGINS_BAD_CONF_OPT += --disable-videomeasure
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOPARSERS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-videoparsers
else
GST_PLUGINS_BAD_CONF_OPT += --disable-videoparsers
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_Y4M),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-y4m
else
GST_PLUGINS_BAD_CONF_OPT += --disable-y4m
endif

# plugins with deps
ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_APEXSINK),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-apexsink
GST_PLUGINS_BAD_DEPENDENCIES += openssl
else
GST_PLUGINS_BAD_CONF_OPT += --disable-apexsink
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_BZ2),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-bz2
GST_PLUGINS_BAD_DEPENDENCIES += bzip2
else
GST_PLUGINS_BAD_CONF_OPT += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CDAUDIO),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-cdaudio
GST_PLUGINS_BAD_DEPENDENCIES += libcdaudio
else
GST_PLUGINS_BAD_CONF_OPT += --disable-cdaudio
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CURL),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-curl
GST_PLUGINS_BAD_DEPENDENCIES += libcurl
else
GST_PLUGINS_BAD_CONF_OPT += --disable-curl
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LIBMMS),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-libmms
GST_PLUGINS_BAD_DEPENDENCIES += libmms
else
GST_PLUGINS_BAD_CONF_OPT += --disable-libmms
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_NEON),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-neon
GST_PLUGINS_BAD_DEPENDENCIES += neon
else
GST_PLUGINS_BAD_CONF_OPT += --disable-neon
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RSVG),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-rsvg
GST_PLUGINS_BAD_DEPENDENCIES += librsvg
else
GST_PLUGINS_BAD_CONF_OPT += --disable-rsvg
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDL),y)
GST_PLUGINS_BAD_CONF_ENV += ac_cv_path_SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl-config
GST_PLUGINS_BAD_CONF_OPT += --enable-sdl
GST_PLUGINS_BAD_DEPENDENCIES += sdl
else
GST_PLUGINS_BAD_CONF_OPT += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SNDFILE),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-sndfile
GST_PLUGINS_BAD_DEPENDENCIES += libsndfile
else
GST_PLUGINS_BAD_CONF_OPT += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VCD),y)
GST_PLUGINS_BAD_CONF_OPT += --enable-vcd
else
GST_PLUGINS_BAD_CONF_OPT += --disable-vcd
endif

$(eval $(autotools-package))
