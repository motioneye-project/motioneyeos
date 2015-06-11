################################################################################
#
# gflags
#
################################################################################

GFLAGS_VERSION = v2.1.2
GFLAGS_SITE = $(call github,gflags,gflags,$(GFLAGS_VERSION))
GFLAGS_INSTALL_STAGING = YES
GFLAGS_LICENSE = BSD-3c
GFLAGS_LICENSE_FILES = COPYING.txt

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
GFLAGS_CONF_OPTS = -DBUILD_gflags_LIB=OFF -DCMAKE_CXX_FLAGS=-DNO_THREADS
endif

$(eval $(cmake-package))
