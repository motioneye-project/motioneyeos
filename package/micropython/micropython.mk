################################################################################
#
# micropython
#
################################################################################

MICROPYTHON_VERSION = v1.6
MICROPYTHON_SITE = $(call github,micropython,micropython,$(MICROPYTHON_VERSION))
MICROPYTHON_LICENSE = MIT
MICROPYTHON_LICENSE_FILES = LICENSE
MICROPYTHON_DEPENDENCIES = host-pkgconf libffi

# Use fallback implementation for exception handling on architectures that don't
# have explicit support.
ifeq ($(BR2_i386)$(BR2_x86_64)$(BR2_arm)$(BR2_armeb),)
MICROPYTHON_CFLAGS = -DMICROPY_GCREGS_SETJMP=1
endif

define MICROPYTHON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/unix \
		CROSS_COMPILE=$(TARGET_CROSS) \
		CFLAGS_EXTRA=$(MICROPYTHON_CFLAGS)
endef

define MICROPYTHON_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/unix \
		DESTDIR=$(TARGET_DIR) \
		PREFIX=$(TARGET_DIR)/usr \
		install
endef

$(eval $(generic-package))
