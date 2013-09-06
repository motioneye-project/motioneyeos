################################################################################
#
# gst-plugins-good
#
################################################################################

GST_PLUGINS_GOOD_VERSION = 0.10.31
GST_PLUGINS_GOOD_SOURCE = gst-plugins-good-$(GST_PLUGINS_GOOD_VERSION).tar.xz
GST_PLUGINS_GOOD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-good

GST_PLUGINS_GOOD_CONF_OPT = \
		--disable-debug \
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
GST_PLUGINS_GOOD_CONF_OPT += \
	--enable-x \
	--enable-xshm \
	--enable-xvideo
else
GST_PLUGINS_GOOD_CONF_OPT += \
	--disable-x \
	--disable-xshm \
	--disable-xvideo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_JPEG),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-jpeg
GST_PLUGINS_GOOD_DEPENDENCIES += jpeg
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PNG),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-libpng
GST_PLUGINS_GOOD_DEPENDENCIES += libpng
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-libpng
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_BZ2),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-bz2
GST_PLUGINS_GOOD_DEPENDENCIES += bzip2
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_ZLIB),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-zlib
GST_PLUGINS_GOOD_DEPENDENCIES += zlib
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-zlib
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_AUDIOPARSERS),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-audioparsers
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-audioparsers
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_DEBUGUTILS),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-debugutils
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_DEINTERLACE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-deinterlace
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-deinterlace
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_FLV),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-flv
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-flv
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_IMAGEFREEZE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-imagefreeze
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-imagefreeze
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_INTERLEAVE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-interleave
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-interleave
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ISOMP4),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-isomp4
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-isomp4
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_RTPMANAGER),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-rtpmanager
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-rtpmanager
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_RTSP),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-rtsp
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-rtsp
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SHAPEWIPE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-shapewipe
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-shapewipe
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_VIDEOFILTER),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-videofilter
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-videofilter
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

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_Y4M),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-y4m
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-y4m
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_V4L2),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-gst_v4l2
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-gst_v4l2
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_ANNODEX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-annodex
GST_PLUGINS_GOOD_DEPENDENCIES += libxml2
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-annodex
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_CAIRO),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-cairo
GST_PLUGINS_GOOD_DEPENDENCIES += cairo
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-cairo
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_FLAC),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-flac
GST_PLUGINS_GOOD_DEPENDENCIES += flac
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-flac
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_GDKPIXBUF),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-gdk_pixbuf
GST_PLUGINS_GOOD_DEPENDENCIES += gdk-pixbuf
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-gdk_pixbuf
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_OSS),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-oss
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-oss
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_OSS4),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-oss4
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-oss4
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_PULSE),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-pulse
GST_PLUGINS_GOOD_DEPENDENCIES += pulseaudio
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-pulse
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SOUPHTTPSRC),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-soup
GST_PLUGINS_GOOD_DEPENDENCIES += libsoup
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-soup
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_SPEEX),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-speex
GST_PLUGINS_GOOD_DEPENDENCIES += speex
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-speex
endif

ifeq ($(BR2_PACKAGE_GST_PLUGINS_GOOD_PLUGIN_WAVPACK),y)
GST_PLUGINS_GOOD_CONF_OPT += --enable-wavpack
GST_PLUGINS_GOOD_DEPENDENCIES += wavpack
else
GST_PLUGINS_GOOD_CONF_OPT += --disable-wavpack
endif

$(eval $(autotools-package))
