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
LIBNICE_CONF_OPTS = \
	--without-gstreamer \
	--without-gstreamer-0.10

$(eval $(autotools-package))
