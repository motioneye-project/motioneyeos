################################################################################
#
# gst-plugins-bad
#
################################################################################

GST_PLUGINS_BAD_VERSION = 0.10.23
GST_PLUGINS_BAD_SOURCE = gst-plugins-bad-$(GST_PLUGINS_BAD_VERSION).tar.xz
GST_PLUGINS_BAD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-bad

GST_PLUGINS_BAD_CONF_OPTS = \
		--disable-examples

GST_PLUGINS_BAD_DEPENDENCIES = gst-plugins-base gstreamer

ifeq ($(BR2_PACKAGE_ORC),y)
GST_PLUGINS_BAD_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ADPCMDEC),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-adpcmdec
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-adpcmdec
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ADPCMENC),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-adpcmenc
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-adpcmenc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AIFF),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-aiff
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-aiff
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ASFMUX),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-asfmux
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-asfmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AUDIOVISUALIZERS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-audiovisualizers
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-audiovisualizers
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_AUTOCONVERT),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-autoconvert
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-autoconvert
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_BAYER),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-bayer
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-bayer
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CAMERABIN),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-camerabin
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-camerabin
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CAMERABIN2),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-camerabin2
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-camerabin2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CDXAPARSE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-cdxaparse
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-cdxaparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_COLOREFFECTS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-coloreffects
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-coloreffects
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_COLORSPACE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-colorspace
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-colorspace
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DATAURISRC),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-dataurisrc
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-dataurisrc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DCCP),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-dccp
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-dccp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DEBUGUTILS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-debugutils
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DECKLINK),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-decklink
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-decklink
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DTMF),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-dtmf
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-dtmf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DVBSUBOVERLAY),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-dvbsuboverlay
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-dvbsuboverlay
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DVDSPU),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-dvdspu
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-dvdspu
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FACEOVERLAY),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-faceoverlay
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-faceoverlay
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FESTIVAL),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-festival
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-festival
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FIELDANALYSIS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-fieldanalysis
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-fieldanalysis
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FREEZE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-freeze
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-freeze
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FREEVERB),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-freeverb
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-freeverb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FREI0R),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-frei0r
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-frei0r
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_GAUDIEFFECTS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-gaudieffects
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-gaudieffects
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_GEOMETRICTRANSFORM),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-geometrictransform
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-geometrictransform
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_GSETTINGS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-gsettings
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-gsettings
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_H264PARSE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-h264parse
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-h264parse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_HDVPARSE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-hdvparse
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-hdvparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_HLS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-hls
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-hls
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_ID3TAG),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-id3tag
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-id3tag
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_INTER),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-inter
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-inter
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_INTERLACE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-interlace
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-interlace
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_IVFPARSE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-ivfparse
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-ivfparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_JP2KDECIMATOR),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-jp2kdecimator
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-jp2kdecimator
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_JPEGFORMAT),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-jpegformat
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-jpegformat
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LEGACYRESAMPLE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-legacyresample
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-legacyresample
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LIBRFB),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-librfb
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-librfb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LINSYS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-linsys
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-linsys
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LIVEADDER),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-liveadder
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-liveadder
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGDEMUX),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-mpegdemux
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-mpegdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGPSMUX),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-mpegpsmux
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-mpegpsmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGTSDEMUX),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-mpegtsdemux
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-mpegtsdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGTSMUX),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-mpegtsmux
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-mpegtsmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MPEGVIDEOPARSE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-mpegvideoparse
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-mpegvideoparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MVE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-mve
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-mve
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MXF),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-mxf
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-mxf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_NSF),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-nsf
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-nsf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_NUVDEMUX),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-nuvdemux
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-nuvdemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_PATCHDETECT),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-patchdetect
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-patchdetect
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_PCAPPARSE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-pcapparse
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-pcapparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_PNM),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-pnm
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-pnm
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RAWPARSE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-rawparse
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-rawparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_REAL),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-real
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-real
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_REMOVESILENCE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-removesilence
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-removesilence
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RTPMUX),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-rtpmux
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-rtpmux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RTPVP8),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-rtpvp8
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-rtpvp8
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SCALETEMPO),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-scaletempo
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-scaletempo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDI),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-sdi
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-sdi
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDP),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-sdp
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-sdp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SEGMENTCLIP),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-segmentclip
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-segmentclip
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SIREN),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-siren
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-siren
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SMOOTH),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-smooth
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-smooth
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SPEED),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-speed
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-speed
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SUBENC),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-subenc
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-subenc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_STEREO),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-stereo
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-stereo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_TTA),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-tta
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-tta
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOFILTERS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-videofilters
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-videofilters
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOMAXRATE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-videomaxrate
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-videomaxrate
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOMEASURE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-videomeasure
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-videomeasure
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOPARSERS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-videoparsers
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-videoparsers
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VIDEOSIGNAL),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-videosignal
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-videosignal
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VMNC),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-vmnc
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-vmnc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_Y4M),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-y4m
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-y4m
endif

# plugins with deps
ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_APEXSINK),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-apexsink
GST_PLUGINS_BAD_DEPENDENCIES += openssl
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-apexsink
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_BZ2),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-bz2
GST_PLUGINS_BAD_DEPENDENCIES += bzip2
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CDAUDIO),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-cdaudio
GST_PLUGINS_BAD_DEPENDENCIES += libcdaudio
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-cdaudio
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_CURL),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-curl
GST_PLUGINS_BAD_DEPENDENCIES += libcurl
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-curl
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DIRECTFB),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-directfb
GST_PLUGINS_BAD_DEPENDENCIES += directfb
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-directfb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_DVB),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-dvb
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-dvb
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FAAD),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-faad
GST_PLUGINS_BAD_DEPENDENCIES += faad2
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-faad
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_FBDEV),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-fbdev
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-fbdev
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_LIBMMS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-libmms
GST_PLUGINS_BAD_DEPENDENCIES += libmms
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-libmms
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_MUSEPACK),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-musepack
GST_PLUGINS_BAD_DEPENDENCIES += musepack
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-musepack
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_NEON),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-neon
GST_PLUGINS_BAD_DEPENDENCIES += neon
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-neon
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_OPUS),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-opus
GST_PLUGINS_BAD_DEPENDENCIES += opus
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_RSVG),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-rsvg
GST_PLUGINS_BAD_DEPENDENCIES += librsvg
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-rsvg
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SDL),y)
GST_PLUGINS_BAD_CONF_ENV += ac_cv_path_SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl-config
GST_PLUGINS_BAD_CONF_OPTS += --enable-sdl
GST_PLUGINS_BAD_DEPENDENCIES += sdl
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_SNDFILE),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-sndfile
GST_PLUGINS_BAD_DEPENDENCIES += libsndfile
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BAD_PLUGIN_VCD),y)
GST_PLUGINS_BAD_CONF_OPTS += --enable-vcd
else
GST_PLUGINS_BAD_CONF_OPTS += --disable-vcd
endif

$(eval $(autotools-package))
