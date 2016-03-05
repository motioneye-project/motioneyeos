################################################################################
#
# fmlib
#
################################################################################

FMLIB_VERSION = fsl-sdk-v1.5-rc3
FMLIB_SITE = git://git.freescale.com/ppc/sdk/fmlib.git
FMLIB_LICENSE = BSD-3c, GPLv2+
FMLIB_LICENSE_FILES = COPYING
FMLIB_DEPENDENCIES = linux
FMLIB_INSTALL_STAGING = YES

# This package installs a static library only, so there's
# nothing to install to the target
FMLIB_INSTALL_TARGET = NO

FMLIB_MAKE_OPTS = \
	CC="$(TARGET_CC)" \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	KERNEL_SRC="$(LINUX_DIR)" \
	PREFIX="$(STAGING_DIR)/usr"

ifeq ($(BR2_powerpc_e500mc),y)
FMLIB_ARCHTYPE = ppce500mc
endif

define FMLIB_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(FMLIB_MAKE_OPTS) -C $(@D) libfm-$(FMLIB_ARCHTYPE).a
endef

define FMLIB_INSTALL_STAGING_CMDS
	$(FMLIB_MAKE_ENV) $(MAKE) $(FMLIB_MAKE_OPTS) -C $(@D) install-libfm-$(FMLIB_ARCHTYPE)
endef

$(eval $(generic-package))
