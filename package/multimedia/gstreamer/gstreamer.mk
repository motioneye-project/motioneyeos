#############################################################
#
# gstreamer
#
#############################################################
GSTREAMER_VERSION = 0.10.21
GSTREAMER_SOURCE = gstreamer-$(GSTREAMER_VERSION).tar.bz2
GSTREAMER_SITE = http://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER_INSTALL_STAGING = YES

# Checking if unaligned memory access works correctly cannot be done when cross
# compiling. For the following architectures there is no information available
# in the configure script.
ifeq ($(BR2_avr32),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=no
endif
ifeq ($(BR2_nios2),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=no
endif
ifeq ($(BR2_s390),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=yes
endif

GSTREAMER_CONF_OPT = \
		$(DISABLE_NLS) \
		$(DISABLE_LARGEFILE) \
		--disable-examples \
		--disable-tests \
		--disable-failing-tests

GSTREAMER_DEPENDENCIES = libglib2 libxml2 pkgconfig

$(eval $(call AUTOTARGETS,package/multimedia,gstreamer))
