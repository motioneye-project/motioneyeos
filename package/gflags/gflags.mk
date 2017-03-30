################################################################################
#
# gflags
#
################################################################################

GFLAGS_VERSION = v2.2.0
GFLAGS_SITE = $(call github,gflags,gflags,$(GFLAGS_VERSION))
GFLAGS_INSTALL_STAGING = YES
GFLAGS_LICENSE = BSD-3-Clause
GFLAGS_LICENSE_FILES = COPYING.txt

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
GFLAGS_CONF_OPTS = -DBUILD_gflags_LIB=OFF \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -DNO_THREADS"
endif

$(eval $(cmake-package))
