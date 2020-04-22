################################################################################
#
# libspatialindex
#
################################################################################

LIBSPATIALINDEX_VERSION = 1.9.3
LIBSPATIALINDEX_SITE = \
	https://github.com/libspatialindex/libspatialindex/releases/download/$(LIBSPATIALINDEX_VERSION)
LIBSPATIALINDEX_SOURCE = spatialindex-src-$(LIBSPATIALINDEX_VERSION).tar.bz2
LIBSPATIALINDEX_INSTALL_STAGING = YES
LIBSPATIALINDEX_LICENSE = MIT
LIBSPATIALINDEX_LICENSE_FILES = COPYING

LIBSPATIALINDEX_CXXFLAGS = $(TARGET_CXXFLAGS)
LIBSPATIALINDEX_CONF_OPTS = \
	-DSIDX_BUILD_TESTS=OFF \
	-DCMAKE_CXX_FLAGS="$(LIBSPATIALINDEX_CXXFLAGS)"

ifeq ($(BR2_TOOLCHAIN_HAS_GCC_BUG_68485),y)
LIBSPATIALINDEX_CXXFLAGS += -O0
endif

$(eval $(cmake-package))
