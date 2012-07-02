
#############################################################
#
# gstreamer
#
#############################################################
GSTREAMER_VERSION = 0.10.36
GSTREAMER_SOURCE = gstreamer-$(GSTREAMER_VERSION).tar.bz2
GSTREAMER_SITE = http://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER_INSTALL_STAGING = YES

# Checking if unaligned memory access works correctly cannot be done when cross
# compiling. For the following architectures there is no information available
# in the configure script.
ifeq ($(BR2_avr32),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=no
endif

GSTREAMER_CONF_OPT = \
		--disable-examples \
		--disable-tests \
		--disable-failing-tests \
		--disable-loadsave \
		$(if $(BR2_PACKAGE_GSTREAMER_GST_DEBUG),,--disable-gst-debug)

GSTREAMER_DEPENDENCIES = libglib2 host-pkg-config

$(eval $(autotools-package))
