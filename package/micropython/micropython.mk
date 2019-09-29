################################################################################
#
# micropython
#
################################################################################

MICROPYTHON_VERSION = v1.9.4
MICROPYTHON_SITE = $(call github,micropython,micropython,$(MICROPYTHON_VERSION))
MICROPYTHON_LICENSE = MIT
MICROPYTHON_LICENSE_FILES = LICENSE
MICROPYTHON_DEPENDENCIES = host-pkgconf libffi

# Use fallback implementation for exception handling on architectures that don't
# have explicit support.
ifeq ($(BR2_i386)$(BR2_x86_64)$(BR2_arm)$(BR2_armeb),)
MICROPYTHON_CFLAGS = -DMICROPY_GCREGS_SETJMP=1
endif

# When building from a tarball we don't have some of the dependencies that are in
# the git repository as submodules
MICROPYTHON_MAKE_OPTS = MICROPY_PY_BTREE=0
MICROPYTHON_MAKE_OPTS += MICROPY_PY_USSL=0

define MICROPYTHON_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/mpy-cross
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/ports/unix \
		$(MICROPYTHON_MAKE_OPTS) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		CFLAGS_EXTRA=$(MICROPYTHON_CFLAGS)
endef

define MICROPYTHON_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/ports/unix \
		$(MICROPYTHON_MAKE_OPTS) \
		CROSS_COMPILE=$(TARGET_CROSS) \
		CFLAGS_EXTRA=$(MICROPYTHON_CFLAGS) \
		DESTDIR=$(TARGET_DIR) \
		PREFIX=$(TARGET_DIR)/usr \
		install
endef

$(eval $(generic-package))
