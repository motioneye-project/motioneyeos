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

# Workaround gcc ICE
# (https://gcc.gnu.org/bugzilla/show_bug.cgi?id=68485)
ifeq ($(BR2_microblaze),y)
LIBSPATIALINDEX_CXXFLAGS += -O0
endif

$(eval $(autotools-package))
