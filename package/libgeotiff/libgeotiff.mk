################################################################################
#
# libgeotiff
#
################################################################################

LIBGEOTIFF_VERSION = 1.3.0
LIBGEOTIFF_SITE = http://download.osgeo.org/geotiff/libgeotiff
LIBGEOTIFF_DEPENDENCIES = tiff
LIBGEOTIFF_INSTALL_STAGING = YES

$(eval $(autotools-package))
