################################################################################
#
# gst-plugins-good
#
################################################################################

GST_PLUGINS_GOOD_VERSION = 0.10.31
GST_PLUGINS_GOOD_SOURCE = gst-plugins-good-$(GST_PLUGINS_GOOD_VERSION).tar.xz
GST_PLUGINS_GOOD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-good
GST_PLUGINS_GOOD_LICENSE = LGPLv2.1+
GST_PLUGINS_GOOD_LICENSE_FILES = COPYING

GST_PLUGINS_GOOD_CONF_OPTS = \
	--disable-examples \
	--disable-directsound \
	--disable-sunaudio \
	--disable-osx_audio \
	--disable-osx_video \
	--disable-aalib \
	--disable-aalibtest \
	--disable-esd \
	--disable-esdtest \
	--disable-shout2

GST_PLUGINS_GOOD_DEPENDENCIES = gstreamer gst-plugins-base

ifeq ($(BR2_PACKAGE_XORG7),y)
GST_PLUGINS_GOOD_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
GST_PLUGINS_GOOD_CONF_OPTS += \
	--enable-x \
	--enable-xshm \
	--enable-xvideo
else
GST_PLUGINS_GOOD_CONF_OPTS += \
	--disable-x \
	--disable-xshm \
	--disable-xvideo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_JPEG),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-jpeg
GST_PLUGINS_GOOD_DEPENDENCIES += jpeg
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PNG),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-libpng
GST_PLUGINS_GOOD_DEPENDENCIES += libpng
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-libpng
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_BZ2),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-bz2
GST_PLUGINS_GOOD_DEPENDENCIES += bzip2
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_ZLIB),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-zlib
GST_PLUGINS_GOOD_DEPENDENCIES += zlib
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ALPHA),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-alpha
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-alpha
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_APETAG),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-apetag
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-apetag
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUDIOFX),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-audiofx
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-audiofx
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUDIOPARSERS),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-audioparsers
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-audioparsers
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUPARSE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-auparse
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-auparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUTODETECT),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-autodetect
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-autodetect
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AVI),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-avi
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-avi
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_CUTTER),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-cutter
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-cutter
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_DEBUGUTILS),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-debugutils
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_DEINTERLACE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-deinterlace
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-deinterlace
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_EFFECTV),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-effectv
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-effectv
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_EQUALIZER),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-equalizer
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-equalizer
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_FLV),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-flv
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-flv
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_FLX),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-flx
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-flx
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_GOOM),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-goom
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-goom
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_GOOM2K1),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-goom2k1
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-goom2k1
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ID3DEMUX),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-id3demux
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-id3demux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ICYDEMUX),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-icydemux
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-icydemux
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_IMAGEFREEZE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-imagefreeze
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-imagefreeze
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_INTERLEAVE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-interleave
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-interleave
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ISOMP4),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-isomp4
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-isomp4
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_LAW),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-law
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-law
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_LEVEL),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-level
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-level
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MATROSKA),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-matroska
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-matroska
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MONOSCOPE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-monoscope
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-monoscope
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MULTIFILE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-multifile
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-multifile
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_MULTIPART),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-multipart
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-multipart
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_REPLAYGAIN),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-replaygain
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-replaygain
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_RTP),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-rtp
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-rtp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_RTPMANAGER),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-rtpmanager
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-rtpmanager
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_RTSP),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-rtsp
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-rtsp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SHAPEWIPE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-shapewipe
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-shapewipe
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SMPTE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-smpte
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-smpte
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SPECTRUM),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-spectrum
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-spectrum
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_UDP),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-udp
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-udp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOBOX),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-videobox
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-videobox
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOCROP),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-videocrop
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-videocrop
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOFILTER),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-videofilter
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-videofilter
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOMIXER),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-videomixer
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-videomixer
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_WAVENC),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-wavenc
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-wavenc
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_WAVPARSE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-wavparse
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-wavparse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_Y4M),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-y4m
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-y4m
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_V4L2),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-gst_v4l2
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-gst_v4l2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ANNODEX),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-annodex
GST_PLUGINS_GOOD_DEPENDENCIES += libxml2
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-annodex
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_CAIRO),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-cairo
GST_PLUGINS_GOOD_DEPENDENCIES += cairo
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-cairo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_FLAC),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-flac
GST_PLUGINS_GOOD_DEPENDENCIES += flac
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-flac
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_GDKPIXBUF),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-gdk_pixbuf
GST_PLUGINS_GOOD_DEPENDENCIES += gdk-pixbuf
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-gdk_pixbuf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_OSS),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-oss
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-oss
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_OSS4),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-oss4
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-oss4
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_PULSE),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-pulse
GST_PLUGINS_GOOD_DEPENDENCIES += pulseaudio
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-pulse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SOUPHTTPSRC),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-soup
GST_PLUGINS_GOOD_DEPENDENCIES += libsoup
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-soup
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SPEEX),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-speex
GST_PLUGINS_GOOD_DEPENDENCIES += speex
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-speex
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_WAVPACK),y)
GST_PLUGINS_GOOD_CONF_OPTS += --enable-wavpack
GST_PLUGINS_GOOD_DEPENDENCIES += wavpack
else
GST_PLUGINS_GOOD_CONF_OPTS += --disable-wavpack
endif

$(eval $(autotools-package))
