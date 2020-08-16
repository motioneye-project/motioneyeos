################################################################################
#
# gst1-plugins-bayer2rgb-neon
#
################################################################################

GST1_PLUGINS_BAYER2RGB_NEON_VERSION = 0.3
GST1_PLUGINS_BAYER2RGB_NEON_SOURCE = gst-bayer2rgb-neon-v$(GST1_PLUGINS_BAYER2RGB_NEON_VERSION).tar.bz2
GST1_PLUGINS_BAYER2RGB_NEON_SITE = https://git.phytec.de/gst-bayer2rgb-neon/snapshot
GST1_PLUGINS_BAYER2RGB_NEON_LICENSE = GPL-3.0
GST1_PLUGINS_BAYER2RGB_NEON_LICENSE_FILES = COPYING

GST1_PLUGINS_BAYER2RGB_NEON_INSTALL_STAGING = YES

GST1_PLUGINS_BAYER2RGB_NEON_DEPENDENCIES = \
	host-pkgconf \
	gstreamer1 \
	gst1-plugins-base \
	bayer2rgb-neon

GST1_PLUGINS_BAYER2RGB_NEON_AUTORECONF = YES

$(eval $(autotools-package))
