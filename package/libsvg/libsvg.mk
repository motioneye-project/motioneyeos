################################################################################
#
# libsvg
#
################################################################################

LIBSVG_VERSION         = 0.1.4
LIBSVG_SITE            = http://cairographics.org/snapshots/
LIBSVG_DEPENDENCIES    = host-pkgconf libpng libjpeg
LIBSVG_INSTALL_STAGING = YES
LIBSVG_LICENSE         = LGPLv2+
LIBSVG_LICENSE_FILES   = COPYING

# libsvg needs at last a XML parser
ifeq ($(BR2_PACKAGE_EXPAT),y)
LIBSVG_CONF_OPT += --with-expat
LIBSVG_DEPENDENCIES += expat
else
LIBSVG_CONF_OPT += --with-libxml2
LIBSVG_DEPENDENCIES += libxml2
endif

$(eval $(autotools-package))
