################################################################################
#
# gst1-plugins-good
#
################################################################################

GST1_PLUGINS_GOOD_VERSION = 1.12.3
GST1_PLUGINS_GOOD_SOURCE = gst-plugins-good-$(GST1_PLUGINS_GOOD_VERSION).tar.xz
GST1_PLUGINS_GOOD_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-good
GST1_PLUGINS_GOOD_LICENSE_FILES = COPYING
GST1_PLUGINS_GOOD_LICENSE = LGPL-2.1+

GST1_PLUGINS_GOOD_CONF_OPTS = \
	--disable-valgrind \
	--disable-examples \
	--disable-directsound \
	--disable-waveform \
	--disable-sunaudio \
	--disable-osx_audio \
	--disable-osx_video \
	--disable-aalib \
	--disable-aalibtest \
	--disable-libcaca

# Options which require currently unpackaged libraries
GST1_PLUGINS_GOOD_CONF_OPTS += \
	--disable-jack \
	--disable-libdv \
	--disable-dv1394 \
	--disable-shout2

GST1_PLUGINS_GOOD_DEPENDENCIES = gstreamer1 gst1-plugins-base

ifeq ($(BR2_PACKAGE_LIBV4L),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --with-libv4l2
GST1_PLUGINS_GOOD_DEPENDENCIES += libv4l
else
GST1_PLUGINS_GOOD_CONF_OPTS += --without-libv4l2
endif

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-orc
GST1_PLUGINS_GOOD_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ALPHA),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-alpha
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-alpha
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_APETAG),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-apetag
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-apetag
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUDIOFX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-audiofx
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-audiofx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUDIOPARSERS),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-audioparsers
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-audioparsers
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUPARSE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-auparse
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-auparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUTODETECT),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-autodetect
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-autodetect
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AVI),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-avi
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-avi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_CUTTER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-cutter
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-cutter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DEBUGUTILS),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-debugutils
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DEINTERLACE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-deinterlace
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-deinterlace
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DTMF),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-dtmf
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-dtmf
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_EFFECTV),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-effectv
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-effectv
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_EQUALIZER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-equalizer
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-equalizer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLV),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-flv
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-flv
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-flx
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-flx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GOOM),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-goom
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-goom
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GOOM2K1),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-goom2k1
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-goom2k1
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ICYDEMUX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-icydemux
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-icydemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ID3DEMUX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-id3demux
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-id3demux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_IMAGEFREEZE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-imagefreeze
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-imagefreeze
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_INTERLEAVE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-interleave
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-interleave
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ISOMP4),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-isomp4
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-isomp4
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_LAW),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-law
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-law
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_LEVEL),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-level
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-level
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MATROSKA),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-matroska
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-matroska
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MONOSCOPE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-monoscope
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-monoscope
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MULTIFILE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-multifile
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-multifile
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MULTIPART),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-multipart
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-multipart
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_REPLAYGAIN),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-replaygain
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-replaygain
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-rtp
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-rtp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTPMANAGER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-rtpmanager
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-rtpmanager
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTSP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-rtsp
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-rtsp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SHAPEWIPE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-shapewipe
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-shapewipe
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SMPTE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-smpte
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-smpte
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SPECTRUM),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-spectrum
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-spectrum
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_UDP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-udp
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-udp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOBOX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-videobox
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-videobox
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOCROP),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-videocrop
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-videocrop
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOFILTER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-videofilter
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-videofilter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOMIXER),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-videomixer
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-videomixer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVENC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-wavenc
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-wavenc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVPARSE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-wavparse
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-wavparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_Y4M),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-y4m
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-y4m
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_OSS),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-oss
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-oss
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_OSS4),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-oss4
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-oss4
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_V4L2),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-gst_v4l2
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-gst_v4l2
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_V4L2_PROBE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-v4l2-probe
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-v4l2-probe
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
GST1_PLUGINS_GOOD_CONF_OPTS += \
	--enable-x \
	$(if $(BR2_PACKAGE_XLIB_LIBXFIXES),xlib_libXfixes) \
	$(if $(BR2_PACKAGE_XLIB_LIBXDAMAGE),xlib_libXdamage)
else
GST1_PLUGINS_GOOD_CONF_OPTS += \
	--disable-x
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_CAIRO),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-cairo
GST1_PLUGINS_GOOD_DEPENDENCIES += cairo
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-cairo
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLAC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-flac
GST1_PLUGINS_GOOD_DEPENDENCIES += flac
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-flac
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GDKPIXBUF),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-gdk_pixbuf
GST1_PLUGINS_GOOD_DEPENDENCIES += gdk-pixbuf
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-gdk_pixbuf
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_JPEG),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-jpeg
GST1_PLUGINS_GOOD_DEPENDENCIES += jpeg
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PNG),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-libpng
GST1_PLUGINS_GOOD_DEPENDENCIES += libpng
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-libpng
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_PULSE),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-pulse
GST1_PLUGINS_GOOD_DEPENDENCIES += pulseaudio
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-pulse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SOUPHTTPSRC),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-soup
GST1_PLUGINS_GOOD_DEPENDENCIES += libsoup
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-soup
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SPEEX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-speex
GST1_PLUGINS_GOOD_DEPENDENCIES += speex
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_TAGLIB),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-taglib
GST1_PLUGINS_GOOD_DEPENDENCIES += taglib
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-taglib
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VPX),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-vpx
GST1_PLUGINS_GOOD_DEPENDENCIES += libvpx
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-vpx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVPACK),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-wavpack
GST1_PLUGINS_GOOD_DEPENDENCIES += wavpack
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-wavpack
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_ZLIB),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-zlib
GST1_PLUGINS_GOOD_DEPENDENCIES += zlib
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_BZ2),y)
GST1_PLUGINS_GOOD_CONF_OPTS += --enable-bz2
GST1_PLUGINS_GOOD_DEPENDENCIES += bzip2
else
GST1_PLUGINS_GOOD_CONF_OPTS += --disable-bz2
endif

$(eval $(autotools-package))
