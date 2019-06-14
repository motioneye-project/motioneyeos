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

# 0001-configure.ac-do-not-force-O2.patch
LIBSPATIALINDEX_AUTORECONF = YES

LIBSPATIALINDEX_CXXFLAGS = $(TARGET_CXXFLAGS)
LIBSPATIALINDEX_CONF_ENV = CXXFLAGS="$(LIBSPATIALINDEX_CXXFLAGS)"

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
LIBSPATIALINDEX_CXXFLAGS += -O0
endif

$(eval $(autotools-package))
