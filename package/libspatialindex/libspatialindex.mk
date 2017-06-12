################################################################################
#
# libspatialindex
#
################################################################################

LIBSPATIALINDEX_VERSION = 1.8.5
LIBSPATIALINDEX_SITE = http://download.osgeo.org/libspatialindex
LIBSPATIALINDEX_SOURCE = spatialindex-src-$(LIBSPATIALINDEX_VERSION).tar.bz2
LIBSPATIALINDEX_INSTALL_STAGING = YES
LIBSPATIALINDEX_LICENSE = MIT
LIBSPATIALINDEX_LICENSE_FILES = COPYING

$(eval $(autotools-package))
