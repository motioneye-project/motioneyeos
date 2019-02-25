################################################################################
#
# meson
#
################################################################################

MESON_VERSION = 0.52.0
MESON_SITE = https://github.com/mesonbuild/meson/releases/download/$(MESON_VERSION)
MESON_LICENSE = Apache-2.0
MESON_LICENSE_FILES = COPYING
MESON_SETUP_TYPE = setuptools

HOST_MESON_DEPENDENCIES = host-ninja
HOST_MESON_NEEDS_HOST_PYTHON = python3

HOST_MESON_TARGET_ENDIAN = $(call LOWERCASE,$(BR2_ENDIAN))
HOST_MESON_TARGET_CPU = $(GCC_TARGET_CPU)

# https://mesonbuild.com/Reference-tables.html#cpu-families
ifeq ($(BR2_arcle)$(BR2_arceb),y)
HOST_MESON_TARGET_CPU_FAMILY = arc
else ifeq ($(BR2_arm)$(BR2_armeb),y)
HOST_MESON_TARGET_CPU_FAMILY = arm
else ifeq ($(BR2_aarch64)$(BR2_aarch64_be),y)
HOST_MESON_TARGET_CPU_FAMILY = aarch64
else ifeq ($(BR2_i386),y)
HOST_MESON_TARGET_CPU_FAMILY = x86
else ifeq ($(BR2_mips)$(BR2_mipsel),y)
HOST_MESON_TARGET_CPU_FAMILY = mips
else ifeq ($(BR2_mips64)$(BR2_mips64el),y)
HOST_MESON_TARGET_CPU_FAMILY = mips64
else ifeq ($(BR2_powerpc),y)
HOST_MESON_TARGET_CPU_FAMILY = ppc
else ifeq ($(BR2_powerpc64)$(BR2_powerpc64le),y)
HOST_MESON_TARGET_CPU_FAMILY = ppc64
else ifeq ($(BR2_riscv),y)
HOST_MESON_TARGET_CPU_FAMILY = riscv64
else ifeq ($(BR2_sparc),y)
HOST_MESON_TARGET_CPU_FAMILY = sparc
else ifeq ($(BR2_sparc64),y)
HOST_MESON_TARGET_CPU_FAMILY = sparc64
else ifeq ($(BR2_x86_64),y)
HOST_MESON_TARGET_CPU_FAMILY = x86_64
else
HOST_MESON_TARGET_CPU_FAMILY = $(ARCH)
endif

HOST_MESON_SED_CFLAGS = $(if $(strip $(TARGET_CFLAGS)),`printf '"%s"$(comma) ' $(TARGET_CFLAGS)`)
HOST_MESON_SED_LDFLAGS = $(if $(strip $(TARGET_LDFLAGS)),`printf '"%s"$(comma) ' $(TARGET_LDFLAGS)`)
HOST_MESON_SED_CXXFLAGS = $(if $(strip $(TARGET_CXXFLAGS)),`printf '"%s"$(comma) ' $(TARGET_CXXFLAGS)`)

$(eval $(host-python-package))
