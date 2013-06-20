################################################################################
#
# jsmin
#
################################################################################

JSMIN_VERSION = a9b4755
JSMIN_SITE = http://github.com/douglascrockford/JSMin/tarball/$(JSMIN_VERSION)

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
