################################################################################
#
# libsvg-cairo
#
################################################################################

LIBSVG_CAIRO_VERSION = 0.1.6
LIBSVG_CAIRO_SITE = http://cairographics.org/snapshots
LIBSVG_CAIRO_DEPENDENCIES = cairo libsvg
LIBSVG_CAIRO_INSTALL_STAGING = YES
LIBSVG_CAIRO_LICENSE = LGPLv2.1+
LIBSVG_CAIRO_LICENSE_FILES = COPYING

LIBSVG_CAIRO_CONF_OPTS = --without-x

$(eval $(autotools-package))
