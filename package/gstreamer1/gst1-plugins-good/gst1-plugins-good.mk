################################################################################
#
# gst1-plugins-good
#
################################################################################

GST1_PLUGINS_GOOD_VERSION = 1.2.1
GST1_PLUGINS_GOOD_SOURCE = gst-plugins-good-$(GST1_PLUGINS_GOOD_VERSION).tar.xz
GST1_PLUGINS_GOOD_SITE = http://gstreamer.freedesktop.org/src/gst-plugins-good
GST1_PLUGINS_GOOD_LICENSE_FILES = COPYING
GST1_PLUGINS_GOOD_LICENSE = LGPLv2.1+

GST1_PLUGINS_GOOD_CONF_OPT = \
	--disable-debug \
	--disable-valgrind \
	--disable-examples \
	--disable-directsound \
	--disable-waveform \
	--disable-sunaudio \
	--disable-osx_audio \
	--disable-osx_video \
	--disable-aalib \
	--disable-aalibtest \
	--disable-libcaca \
	--disable-esd \
	--disable-esdtest


# Options which require currently unpackaged libraries
GST1_PLUGINS_GOOD_CONF_OPT += \
	--disable-jack \
	--disable-libdv \
	--disable-dv1394 \
	--disable-shout2 \
	--disable-taglib

GST1_PLUGINS_GOOD_DEPENDENCIES = gstreamer1 gst1-plugins-base

ifeq ($(BR2_PACKAGE_ORC),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-orc
GST1_PLUGINS_GOOD_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ALPHA),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-alpha
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-alpha
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_APETAG),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-apetag
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-apetag
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUDIOFX),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-audiofx
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-audiofx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUDIOPARSERS),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-audioparsers
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-audioparsers
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUPARSE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-auparse
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-auparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AUTODETECT),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-autodetect
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-autodetect
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_AVI),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-avi
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-avi
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_CUTTER),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-cutter
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-cutter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DEBUGUTILS),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-debugutils
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-debugutils
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DEINTERLACE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-deinterlace
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-deinterlace
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_DTMF),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-dtmf
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-dtmf
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_EFFECTV),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-effectv
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-effectv
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_EQUALIZER),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-equalizer
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-equalizer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLV),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-flv
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-flv
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLX),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-flx
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-flx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GOOM),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-goom
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-goom
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GOOM2K1),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-goom2k1
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-goom2k1
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ICYDEMUX),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-icydemux
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-icydemux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ID3DEMUX),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-id3demux
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-id3demux
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_IMAGEFREEZE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-imagefreeze
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-imagefreeze
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_INTERLEAVE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-interleave
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-interleave
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_ISOMP4),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-isomp4
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-isomp4
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_LAW),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-law
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-law
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_LEVEL),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-level
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-level
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MATROSKA),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-matroska
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-matroska
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MONOSCOPE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-monoscope
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-monoscope
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MULTIFILE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-multifile
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-multifile
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_MULTIPART),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-multipart
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-multipart
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_REPLAYGAIN),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-replaygain
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-replaygain
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTP),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-rtp
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-rtp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTPMANAGER),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-rtpmanager
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-rtpmanager
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_RTSP),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-rtsp
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-rtsp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SHAPEWIPE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-shapewipe
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-shapewipe
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SMPTE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-smpte
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-smpte
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SPECTRUM),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-spectrum
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-spectrum
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_UDP),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-udp
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-udp
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOBOX),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-videobox
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-videobox
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOCROP),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-videocrop
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-videocrop
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOFILTER),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-videofilter
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-videofilter
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VIDEOMIXER),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-videomixer
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-videomixer
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVENC),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-wavenc
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-wavenc
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVPARSE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-wavparse
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-wavparse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_Y4M),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-y4m
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-y4m
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_OSS),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-oss
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-oss
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_OSS4),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-oss4
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-oss4
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_V4L2),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-gst_v4l2
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-gst_v4l2
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
GST1_PLUGINS_GOOD_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
GST1_PLUGINS_GOOD_CONF_OPT += \
	--enable-x \
	--enable-xshm \
	--enable-xvideo
else
GST1_PLUGINS_GOOD_CONF_OPT += \
	--disable-x \
	--disable-xshm \
	--disable-xvideo
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_CAIRO),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-cairo
GST1_PLUGINS_GOOD_DEPENDENCIES += cairo
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-cairo
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_FLAC),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-flac
GST1_PLUGINS_GOOD_DEPENDENCIES += flac
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-flac
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_GDKPIXBUF),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-gdk_pixbuf
GST1_PLUGINS_GOOD_DEPENDENCIES += gdk-pixbuf
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-gdk_pixbuf
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_JPEG),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-jpeg
GST1_PLUGINS_GOOD_DEPENDENCIES += jpeg
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-jpeg
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PNG),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-libpng
GST1_PLUGINS_GOOD_DEPENDENCIES += libpng
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-libpng
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_PULSE),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-pulse
GST1_PLUGINS_GOOD_DEPENDENCIES += pulseaudio
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-pulse
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SOUPHTTPSRC),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-soup
GST1_PLUGINS_GOOD_DEPENDENCIES += libsoup
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-soup
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_SPEEX),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-speex
GST1_PLUGINS_GOOD_DEPENDENCIES += speex
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-speex
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_TAGLIB),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-taglib
GST1_PLUGINS_GOOD_DEPENDENCIES += taglib
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-taglib
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_VPX),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-vpx
GST1_PLUGINS_GOOD_DEPENDENCIES += libvpx
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-vpx
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_PLUGIN_WAVPACK),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-wavpack
GST1_PLUGINS_GOOD_DEPENDENCIES += wavpack
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-wavpack
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_ZLIB),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-zlib
GST1_PLUGINS_GOOD_DEPENDENCIES += zlib
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_GOOD_BZ2),y)
GST1_PLUGINS_GOOD_CONF_OPT += --enable-bz2
GST1_PLUGINS_GOOD_DEPENDENCIES += bzip2
else
GST1_PLUGINS_GOOD_CONF_OPT += --disable-bz2
endif

$(eval $(autotools-package))
