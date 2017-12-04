################################################################################
#
# gstreamer1-mm
#
################################################################################

GSTREAMER1_MM_VERSION_MAJOR = 1.10
GSTREAMER1_MM_VERSION = $(GSTREAMER1_MM_VERSION_MAJOR).0
GSTREAMER1_MM_SITE = http://ftp.gnome.org/pub/gnome/sources/gstreamermm/$(GSTREAMER1_MM_VERSION_MAJOR)
GSTREAMER1_MM_SOURCE = gstreamermm-$(GSTREAMER1_MM_VERSION).tar.xz
GSTREAMER1_MM_LICENSE = LGPL-2.1+ (library), GPL-2.0 (examples)
GSTREAMER1_MM_LICENSE_FILES = COPYING COPYING.examples
GSTREAMER1_MM_INSTALL_STAGING = YES
GSTREAMER1_MM_DEPENDENCIES += \
	glibmm \
	gstreamer1 \
	gst1-plugins-base

GSTREAMER1_MM_CONF_OPTS += \
	--disable-gl \
	--enable-unittests=no \
	--disable-deprecated-api

$(eval $(autotools-package))
