################################################################################
#
# gflags
#
################################################################################

GFLAGS_VERSION = 2.2.2
GFLAGS_SITE = $(call github,gflags,gflags,v$(GFLAGS_VERSION))
GFLAGS_INSTALL_STAGING = YES
GFLAGS_LICENSE = BSD-3-Clause
GFLAGS_LICENSE_FILES = COPYING.txt

# Force Release otherwise libraries will be suffixed by _debug which will raise
# unexpected build failures with packages that use gflags (e.g. rocksdb)
GFLAGS_CONF_OPTS = -DCMAKE_BUILD_TYPE=Release

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
GFLAGS_CONF_OPTS += -DBUILD_gflags_LIB=OFF \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -DNO_THREADS"
endif

$(eval $(cmake-package))
