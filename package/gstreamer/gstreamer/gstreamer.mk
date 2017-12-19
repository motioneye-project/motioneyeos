################################################################################
#
# gstreamer
#
################################################################################

GSTREAMER_VERSION = 0.10.36
GSTREAMER_SOURCE = gstreamer-$(GSTREAMER_VERSION).tar.xz
GSTREAMER_SITE = http://gstreamer.freedesktop.org/src/gstreamer
GSTREAMER_INSTALL_STAGING = YES
# COPYING is in fact v2, but most of the code is v2.1+
GSTREAMER_LICENSE = LGPL-2.1+
GSTREAMER_LICENSE_FILES = COPYING

# Checking if unaligned memory access works correctly cannot be done when cross
# compiling. For the following architectures there is no information available
# in the configure script.
ifeq ($(BR2_arc)$(BR2_xtensa)$(BR2_microblaze)$(BR2_nios2)$(BR2_or1k),y)
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

GSTREAMER_DEPENDENCIES = libglib2 host-pkgconf host-bison host-flex \
	$(if $(BR2_PACKAGE_LIBXML2),libxml2)

$(eval $(autotools-package))
