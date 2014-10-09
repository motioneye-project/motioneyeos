################################################################################
#
# libgeotiff
#
################################################################################

LIBGEOTIFF_VERSION = 1.4.0
LIBGEOTIFF_SITE = http://download.osgeo.org/geotiff/libgeotiff
LIBGEOTIFF_DEPENDENCIES = tiff host-pkgconf
LIBGEOTIFF_INSTALL_STAGING = YES
LIBGEOTIFF_AUTORECONF = YES

$(eval $(autotools-package))
