################################################################################
#
# libargon2
#
################################################################################

LIBARGON2_VERSION = 20190702
LIBARGON2_SITE = $(call github,P-H-C,phc-winner-argon2,$(LIBARGON2_VERSION))
LIBARGON2_LICENSE = CC0-1.0 or Apache-2.0
LIBARGON2_LICENSE_FILES = LICENSE
LIBARGON2_INSTALL_STAGING = YES

LIBARGON2_OPTS = LIBRARY_REL=lib

# GCC_TARGET_ARCH is not defined for all architectures, but libargon2
# only uses it to detect if some x86 optimizations can be used, and
# GCC_TARGET_ARCH is defined on x86.
ifneq ($(GCC_TARGET_ARCH),)
LIBARGON2_OPTS += OPTTARGET=$(GCC_TARGET_ARCH)
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
LIBARGON2_OPTS += NO_THREADS=1
endif

define LIBARGON2_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(LIBARGON2_OPTS)
endef

define LIBARGON2_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(LIBARGON2_OPTS) DESTDIR=$(STAGING_DIR) install
endef

define LIBARGON2_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) \
		$(LIBARGON2_OPTS) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
