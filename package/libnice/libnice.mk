################################################################################
#
# libnice
#
################################################################################

LIBNICE_VERSION = 0.1.16
LIBNICE_SITE = http://nice.freedesktop.org/releases
LIBNICE_LICENSE = MPL-1.1 or LGPL-2.1
LIBNICE_LICENSE_FILES = COPYING COPYING.MPL COPYING.LGPL
LIBNICE_DEPENDENCIES = libglib2 host-pkgconf
LIBNICE_INSTALL_STAGING = YES
LIBNICE_CONF_OPTS = --without-gstreamer-0.10

ifeq ($(BR2_PACKAGE_GNUTLS),y)
LIBNICE_CONF_OPTS += --with-crypto-library=gnutls
LIBNICE_DEPENDENCIES += gnutls
else
LIBNICE_CONF_OPTS += \
	--with-crypto-library=openssl \
	--with-openssl=$(STAGING_DIR)/usr
LIBNICE_DEPENDENCIES += openssl
endif

ifeq ($(BR2_PACKAGE_GST1_PLUGINS_BASE),y)
LIBNICE_CONF_OPTS += --with-gstreamer
LIBNICE_DEPENDENCIES += gst1-plugins-base
else
LIBNICE_CONF_OPTS += --without-gstreamer
endif

$(eval $(autotools-package))
