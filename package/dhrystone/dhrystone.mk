################################################################################
#
# dhrystone
#
################################################################################

DHRYSTONE_VERSION = 2
DHRYSTONE_SOURCE = dhry-c
DHRYSTONE_SITE = http://www.netlib.org/benchmark/

define DHRYSTONE_EXTRACT_CMDS
	(cd $(@D) && $(SHELL) $(DL_DIR)/$($(PKG)_SOURCE))
	$(Q)cp $($(PKG)_DIR_PREFIX)/dhrystone/Makefile $(@D)/
endef

define DHRYSTONE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define DHRYSTONE_CLEAN_CMDS
	$(MAKE) -C $(@D) clean
endef

define DHRYSTONE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/dhrystone $(TARGET_DIR)/usr/bin/dhrystone
endef

define DHRYSTONE_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/dhrystone
endef

$(eval $(generic-package))
