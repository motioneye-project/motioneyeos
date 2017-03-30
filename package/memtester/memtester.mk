################################################################################
#
# memtester
#
################################################################################

MEMTESTER_VERSION = 4.3.0
MEMTESTER_SITE = http://pyropus.ca/software/memtester/old-versions
MEMTESTER_LICENSE = GPL-2.0
MEMTESTER_LICENSE_FILES = COPYING

MEMTESTER_TARGET_INSTALL_OPTS = INSTALLPATH=$(TARGET_DIR)/usr

define MEMTESTER_BUILD_CMDS
	$(SED) "s,^cc,$(TARGET_CC)," $(@D)/conf-*
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define MEMTESTER_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(MEMTESTER_TARGET_INSTALL_OPTS) -C $(@D) install
endef

$(eval $(generic-package))
