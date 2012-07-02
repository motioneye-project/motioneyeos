JSMIN_VERSION = a9b47554d5684a55301a2eb7ca8480b7ee7630d4
JSMIN_SITE = git://github.com/douglascrockford/JSMin.git

define JSMIN_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) jsmin
endef

define JSMIN_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/jsmin $(TARGET_DIR)/usr/bin/jsmin
endef

define JSMIN_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/jsmin
endef

define HOST_JSMIN_BUILD_CMDS
	$(HOST_CONFIGURE_OPTS) $(MAKE) -C $(@D) jsmin
endef

define HOST_JSMIN_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/jsmin $(HOST_DIR)/usr/bin/jsmin
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
