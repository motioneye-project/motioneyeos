################################################################################
#
# memtester
#
################################################################################

MEMTESTER_VERSION = 4.3.0
MEMTESTER_SITE = http://pyropus.ca/software/memtester/old-versions/
MEMTESTER_LICENSE = GPLv2
MEMTESTER_LICENSE_FILES = COPYING

MEMTESTER_TARGET_INSTALL_OPTS = INSTALLPATH=$(TARGET_DIR)/usr

define MEMTESTER_BUILD_CMDS
	$(SED) "s,cc,$(TARGET_CC)," $(@D)/conf-*
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define MEMTESTER_INSTALL_TARGET_CMDS
	$(MAKE) $(MEMTESTER_TARGET_INSTALL_OPTS) -C $(@D) install
endef

define MEMTESTER_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/memtester
endef

define MEMTESTER_CLEAN_CMDS
	-$(MAKE) -C $(@D) clean
endef

$(eval $(generic-package))
