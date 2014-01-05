################################################################################
#
# gst1-plugins-bad
#
################################################################################

GST1_PLUGINS_BAD_VERSION = 1.2.2
GST1_PLUGINS_BAD_SOURCE = gst-plugins-bad-$(GST1_PLUGINS_BAD_VERSION).tar.xz
GST1_PLUGINS_BAD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-bad
GST1_PLUGINS_BAD_LICENSE_FILES = COPYING COPYING.LIB
# Unknown and GPL licensed plugins will append to GST1_PLUGINS_BAD_LICENSE if
# enabled.
GST1_PLUGINS_BAD_LICENSE = LGPLv2+ LGPLv2.1+

GST1_PLUGINS_BAD_AUTORECONF = YES
GST1_PLUGINS_BAD_AUTORECONF_OPT = -I $(@D)/common/m4

GST1_PLUGINS_BAD_CONF_OPT = \
	--disable-examples \
	--disable-debug \
	--disable-valgrind \
	--disable-directsound \
	--disable-wsapi \
	--disable-direct3d \
	--disable-directdraw \
	--disable-direct3d9 \
	--disable-directshow \
	--disable-android_media \
	--disable-apple_media \
	--disable-osx_video \
	--disable-sdltest \
	--disable-wininet \
	--disable-acm

# Options which require currently unpackaged libraries
GST1_PLUGINS_BAD_CONF_OPT += \
	--disable-avc \
	--disable-quicktime \
	--disable-mfc \
	--disable-opensles \
	--disable-uvch264 \
	--disable-assrender \
	--disable-voamrwbenc \
	--disable-voaacenc \
	--disable-chromaprint \
	--disable-dash \
	--disable-dc1394 \
	--disable-dts \
	--disable-resindvd \
	--disable-faac \
	--disable-flite \
	--disable-gsm \
	--disable-fluidsynth \
	--disable-kate \
	--disable-ladspa \
	--disable-lv2 \
	--disable-strp \
	--disable-linsys \
	--disable-modplug \
	--disable-mimic \
	--disable-mplex \
	--disable-mythtv \
	--disable-nas \
	--disable-ofa \
	--disable-openal \
	--disable-openjpeg \
	--disable-pvr \
	--disable-timidity \
	--disable-teletextdec \
	--disable-wildmidi \
	--disable-smoothstreaming \
	--disable-soundtouch \
	--disable-spc \
	--disable-gme \
	--disable-xvid \
	--disable-vdpau \
	--disable-sbc \
	--disable-schro \
	--disable-zbar \
	--disable-rtmp \
	--disable-spandsp \
	--disable-gsettings \
	--disable-sndio \
	--disable-hls

GST1_PLUGINS_BAD_DEPENDENCIES = gst1-plugins-base gstreamer1

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_BAD_DEPENDENCIES += orc
GST1_PLUGINS_BAD_CONF_OPT += --enable-orc
endif

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
GST1_PLUGINS_BAD_DEPENDENCIES += bluez_utils
GST1_PLUGINS_BAD_CONF_OPT += --enable-bluez
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-bluez
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ACCURIP),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-accurip
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-accurip
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ADPCMDEC),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-adpcmdec
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-adpcmdec
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ADPCMENC),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-adpcmenc
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-adpcmenc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AIFF),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-aiff
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-aiff
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ASFMUX),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-asfmux
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-asfmux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOFXBAD),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-audiofxbad
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-audiofxbad
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUDIOVISUALIZERS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-audiovisualizers
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-audiovisualizers
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_AUTOCONVERT),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-autoconvert
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-autoconvert
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_BAYER),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-bayer
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-bayer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CAMERABIN2),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-camerabin2
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-camerabin2
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CDXAPARSE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-cdxaparse
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-cdxaparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_COLOREFFECTS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-coloreffects
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-coloreffects
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DATAURISRC),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-dataurisrc
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-dataurisrc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DCCP),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-dccp
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-dccp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DEBUGUTILS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-debugutils
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVBSUBOVERLAY),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-dvbsuboverlay
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-dvbsuboverlay
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVDSPU),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-dvdspu
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-dvdspu
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FACEOVERLAY),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-faceoverlay
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-faceoverlay
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FESTIVAL),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-festival
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-festival
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FIELDANALYSIS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-fieldanalysis
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-fieldanalysis
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FREEVERB),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-freeverb
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-freeverb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FREI0R),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-frei0r
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-frei0r
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GAUDIEFFECTS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-gaudieffects
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-gaudieffects
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GEOMETRICTRANSFORM),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-geometrictransform
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-geometrictransform
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_GDP),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-gdp
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-gdp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_HDVPARSE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-hdvparse
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-hdvparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_ID3TAG),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-id3tag
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-id3tag
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_INTER),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-inter
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-inter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_INTERLACE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-interlace
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-interlace
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_IVFPARSE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-ivfparse
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-ivfparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_IVTC),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-ivtc
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-ivtc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_JP2KDECIMATOR),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-jp2kdecimator
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-jp2kdecimator
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_JPEGFORMAT),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-jpegformat
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-jpegformat
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIBRFB),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-librfb
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-librfb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIVEADDER),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-liveadder
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-liveadder
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MIDI),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-midi
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-midi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mpegdemux
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mpegdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGTSDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mpegtsdemux
GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mpegtsdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGTSMUX),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mpegtsmux
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mpegtsmux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEGPSMUX),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mpegpsmux
GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mpegpsmux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MVE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mve
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mve
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MXF),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mxf
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mxf
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_NUVDEMUX),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-nuvdemux
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-nuvdemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PATCHDETECT),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-patchdetect
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-patchdetect
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PCAPPARSE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-pcapparse
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-pcapparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_PNM),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-pnm
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-pnm
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_RAWPARSE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-rawparse
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-rawparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_REAL),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-real
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-real
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_REMOVESILENCE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-removesilence
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-removesilence
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SDI),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-sdi
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-sdi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SDP),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-sdp
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-sdp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SEGMENTCLIP),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-segmentclip
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-segmentclip
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SIREN),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-siren
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-siren
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SMOOTH),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-smooth
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-smooth
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SPEED),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-speed
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-speed
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SUBENC),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-subenc
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-subenc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_STEREO),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-stereo
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-stereo
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_TTA),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-tta
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-tta
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOFILTERS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-videofilters
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-videofilters
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOMEASURE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-videomeasure
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-videomeasure
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOPARSERS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-videoparsers
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-videoparsers
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VIDEOSIGNAL),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-videosignal
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-videosignal
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VMNC),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-vmnc
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-vmnc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_Y4M),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-y4m
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-y4m
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_YADIF),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-yadif
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-yadif
endif

# Plugins with dependencies

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SHM),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-shm
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-shm
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_VCD),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-vcd
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-vcd
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_APEXSINK),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-apexsink
GST1_PLUGINS_BAD_DEPENDENCIES += openssl
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-apexsink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_BZ2),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-bz2
GST1_PLUGINS_BAD_DEPENDENCIES += bzip2
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CDAUDIO),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-cdaudio
GST1_PLUGINS_BAD_DEPENDENCIES += libcdaudio
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-cdaudio
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_CURL),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-curl
GST1_PLUGINS_BAD_DEPENDENCIES += libcurl
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-curl
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DASH),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-dash
GST1_PLUGINS_BAD_DEPENDENCIES += libxml2
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-dash
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DECKLINK),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-decklink
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-decklink
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WEBP),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-webp
GST1_PLUGINS_BAD_DEPENDENCIES += webp
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-webp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DIRECTFB),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-directfb
GST1_PLUGINS_BAD_DEPENDENCIES += directfb
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-directfb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_WAYLAND),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-wayland
GST1_PLUGINS_BAD_DEPENDENCIES += wayland
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-wayland
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FAAD),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-faad
GST1_PLUGINS_BAD_DEPENDENCIES += faad2
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-faad
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_FBDEV),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-fbdev
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-fbdev
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_LIBMMS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-libmms
GST1_PLUGINS_BAD_DEPENDENCIES += libmms
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-libmms
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPEG2ENC),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mpeg2enc
GST1_PLUGINS_BAD_DEPENDENCIES += libmpeg2
GST1_PLUGINS_BAD_HAS_GPL_LICENSE = y
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mpeg2enc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MPG123),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-mpg123
GST1_PLUGINS_BAD_DEPENDENCIES += mpg123
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-mpg123
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_MUSEPACK),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-musepack
GST1_PLUGINS_BAD_DEPENDENCIES += musepack
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-musepack
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_NEON),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-neon
GST1_PLUGINS_BAD_DEPENDENCIES += neon
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-neon
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPENCV),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-opencv
GST1_PLUGINS_BAD_DEPENDENCIES += opencv
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-opencv
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_OPUS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-opus
GST1_PLUGINS_BAD_DEPENDENCIES += opus
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-opus
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_RSVG),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-rsvg
GST1_PLUGINS_BAD_DEPENDENCIES += librsvg
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-rsvg
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_EGLGLES),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-eglgles
GST1_PLUGINS_BAD_DEPENDENCIES += libegl libgles

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
# RPI has odd locations for several required headers.
GST1_PLUGINS_BAD_CONF_OPT += --with-egl-window-system=rpi
GST1_PLUGINS_BAD_CONF_ENV += \
	CFLAGS="$(TARGET_CFLAGS) \
	-I$(STAGING_DIR)/usr/include/IL \
	-I$(STAGING_DIR)/usr/include/interface/vcos/pthreads \
	-I$(STAGING_DIR)/usr/include/interface/vmcs_host/linux"
endif
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-eglgles
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SDL),y)
GST1_PLUGINS_BAD_CONF_ENV += ac_cv_path_SDL_CONFIG=$(STAGING_DIR)/usr/bin/sdl-config
GST1_PLUGINS_BAD_CONF_OPT += --enable-sdl
GST1_PLUGINS_BAD_DEPENDENCIES += sdl
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-sdl
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_SNDFILE),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-sndfile
GST1_PLUGINS_BAD_DEPENDENCIES += libsndfile
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-sndfile
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_DVB),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-dvb
GST1_PLUGINS_BAD_DEPENDENCIES += dvb-apps
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-dvb
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BAD_PLUGIN_HLS),y)
GST1_PLUGINS_BAD_CONF_OPT += --enable-hls
GST1_PLUGINS_BAD_DEPENDENCIES += gnutls
else
GST1_PLUGINS_BAD_CONF_OPT += --disable-hls
endif

# Add GPL license if GPL licensed plugins enabled.
ifeq ($(GST1_PLUGINS_BAD_HAS_GPL_LICENSE),y)
GST1_PLUGINS_BAD_LICENSE += GPL
endif

# Add Unknown license if Unknown licensed plugins enabled.
ifeq ($(GST1_PLUGINS_BAD_HAS_UNKNOWN_LICENSE),y)
GST1_PLUGINS_BAD_LICENSE += UNKNOWN
endif

# Use the following command to extract license info for plugins.
# # find . -name 'plugin-*.xml' | xargs grep license

$(eval $(autotools-package))
