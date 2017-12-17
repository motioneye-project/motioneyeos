################################################################################
#
# jsmin
#
################################################################################

JSMIN_VERSION = 1bf6ce5f74a9f8752ac7f5d115b8d7ccb31cfe1b
JSMIN_SITE = $(call github,douglascrockford,JSMin,$(JSMIN_VERSION))
JSMIN_LICENSE = MIT
JSMIN_LICENSE_FILES = jsmin.c

define JSMIN_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) jsmin
endef

define JSMIN_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/jsmin $(TARGET_DIR)/usr/bin/jsmin
endef

define HOST_JSMIN_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) jsmin
endef

define HOST_JSMIN_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/jsmin $(HOST_DIR)/usr/bin/jsmin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
