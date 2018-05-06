################################################################################
#
# libnice
#
################################################################################

LIBNICE_VERSION = 0.1.14
LIBNICE_SITE = http://nice.freedesktop.org/releases
LIBNICE_LICENSE = MPL-1.1 or LGPL-2.1
LIBNICE_LICENSE_FILES = COPYING COPYING.MPL COPYING.LGPL
LIBNICE_DEPENDENCIES = gnutls libglib2 host-pkgconf
LIBNICE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_GST_PLUGINS_BASE),y)
LIBNICE_CONF_OPTS += --with-gstreamer-0.10
LIBNICE_DEPENDENCIES += gst-plugins-base
else
LIBNICE_CONF_OPTS += --without-gstreamer-0.10
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE),y)
LIBNICE_CONF_OPTS += --with-gstreamer
LIBNICE_DEPENDENCIES += gst1-plugins-base
else
LIBNICE_CONF_OPTS += --without-gstreamer
endif

$(eval $(autotools-package))
