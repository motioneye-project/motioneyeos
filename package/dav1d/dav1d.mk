################################################################################
#
# dav1d
#
################################################################################

DAV1D_VERSION = 0.5.2
DAV1D_SOURCE = dav1d-$(DAV1D_VERSION).tar.bz2
DAV1D_SITE = https://code.videolan.org/videolan/dav1d/-/archive/$(DAV1D_VERSION)
DAV1D_LICENSE = BSD-2-Clause
DAV1D_LICENSE_FILES = COPYING
DAV1D_INSTALL_STAGING = YES
DAV1D_CONF_OPTS = \
	-Denable_tests=false \
	-Denable_tools=false

ifeq ($(BR2_i386)$(BR2_x86_64),y)
DAV1D_DEPENDENCIES += host-nasm
endif

# ARM assembly requires v6+ ISA
ifeq ($(BR2_ARM_CPU_ARMV4)$(BR2_ARM_CPU_ARMV5)$(BR2_ARM_CPU_ARMV7M),y)
DAV1D_CONF_OPTS += -Denable_asm=false
endif

# Uses __atomic_fetch_add_4
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
DAV1D_LDFLAGS += -latomic
endif

$(eval $(meson-package))
