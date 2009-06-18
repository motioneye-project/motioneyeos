#############################################################
#
# gstreamer
#
#############################################################
GSTREAMER_VERSION = 0.10.23
GSTREAMER_SOURCE = gstreamer-$(GSTREAMER_VERSION).tar.bz2
GSTREAMER_SITE = http://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER_INSTALL_STAGING = YES
GSTREAMER_LIBTOOL_PATCH = NO

# Checking if unaligned memory access works correctly cannot be done when cross
# compiling. For the following architectures there is no information available
# in the configure script.
ifeq ($(BR2_avr32),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=no
endif
ifeq ($(BR2_nios2),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=no
endif

GSTREAMER_CONF_OPT = \
		--disable-examples \
		--disable-tests \
		--disable-failing-tests

GSTREAMER_DEPENDENCIES = libglib2 host-pkgconfig

ifeq ($(BR2_PACKAGE_GSTREAMER_LIBXML2),y)
GSTREAMER_DEPENDENCIES += libxml2
else
GSTREAMER_CONF_OPT += \
	--disable-registry \
	--disable-loadsave
endif

$(eval $(call AUTOTARGETS,package/multimedia,gstreamer))
