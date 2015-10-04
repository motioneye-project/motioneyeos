################################################################################
#
# gstreamer
#
################################################################################

GSTREAMER_VERSION = 0.10.36
GSTREAMER_SOURCE = gstreamer-$(GSTREAMER_VERSION).tar.xz
GSTREAMER_SITE = http://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER_INSTALL_STAGING = YES

# Checking if unaligned memory access works correctly cannot be done when cross
# compiling. For the following architectures there is no information available
# in the configure script.
ifeq ($(BR2_arc)$(BR2_xtensa)$(BR2_microblaze),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=no
endif
ifeq ($(BR2_aarch64),y)
GSTREAMER_CONF_ENV = as_cv_unaligned_access=yes
endif

GSTREAMER_CONF_OPTS = \
	--disable-examples \
	--disable-tests \
	--disable-failing-tests \
	--disable-loadsave \
	$(if $(BR2_PACKAGE_GSTREAMER_GST_DEBUG),,--disable-gst-debug) \
	$(if $(BR2_PACKAGE_GSTREAMER_PLUGIN_REGISTRY),,--disable-registry)

GSTREAMER_DEPENDENCIES = libglib2 host-pkgconf host-bison host-flex

$(eval $(autotools-package))
