################################################################################
#
# pps-tools
#
################################################################################

PPS_TOOLS_VERSION = e2b25049df9a4da28168b7378016f1650d0dfa6b
PPS_TOOLS_SITE = $(call github,ago,pps-tools,$(PPS_TOOLS_VERSION))
PPS_TOOLS_INSTALL_STAGING = YES
PPS_TOOLS_LICENSE = GPL-2.0+
PPS_TOOLS_LICENSE_FILES = COPYING

define PPS_TOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) all
endef

define PPS_TOOLS_INSTALL_STAGING_CMDS
	mkdir -p $(STAGING_DIR)/usr/include/sys $(STAGING_DIR)/usr/bin
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(STAGING_DIR) -C $(@D) install
endef

define PPS_TOOLS_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/include/sys $(TARGET_DIR)/usr/bin
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
