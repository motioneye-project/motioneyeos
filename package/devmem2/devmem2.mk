################################################################################
#
# devmem2
#
################################################################################

DEVMEM2_SITE = http://free-electrons.com/pub/mirror
DEVMEM2_SOURCE = devmem2.c
DEVMEM2_VERSION = 1
DEVMEM2_LICENSE = GPL-2.0+
DEVMEM2_LICENSE_FILES = devmem2.c.license

define DEVMEM2_EXTRACT_CMDS
	cp $(DEVMEM2_DL_DIR)/$($(PKG)_SOURCE) $(@D)/
endef

define DEVMEM2_EXTRACT_LICENSE
	head -n 38 $(@D)/devmem2.c >$(@D)/devmem2.c.license
endef
DEVMEM2_PRE_PATCH_HOOKS += DEVMEM2_EXTRACT_LICENSE

define DEVMEM2_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) devmem2
endef

define DEVMEM2_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/devmem2 $(TARGET_DIR)/sbin/devmem2
endef

$(eval $(generic-package))
