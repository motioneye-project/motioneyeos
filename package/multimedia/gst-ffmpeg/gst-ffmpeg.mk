#############################################################
#
# gst-ffmpeg
#
#############################################################

GST_FFMPEG_VERSION = 0.10.13
GST_FFMPEG_SOURCE = gst-ffmpeg-$(GST_FFMPEG_VERSION).tar.bz2
GST_FFMPEG_SITE = http://gstreamer.freedesktop.org/src/gst-ffmpeg
GST_FFMPEG_INSTALL_STAGING = YES
GST_FFMPEG_DEPENDENCIES = host-pkg-config gstreamer gst-plugins-base ffmpeg
GST_FFMPEG_CONF_OPT = --with-system-ffmpeg

ifeq ($(BR2_PACKAGE_BZIP2),y)
GST_FFMPEG_DEPENDENCIES += bzip2
endif

$(eval $(autotools-package))
