################################################################################
#
# makedevs
#
################################################################################

# source included in buildroot
MAKEDEVS_SOURCE =
HOST_MAKEDEVS_SOURCE =

define MAKEDEVS_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		package/makedevs/makedevs.c -o $(@D)/makedevs
endef

define MAKEDEVS_INSTALL_TARGET_CMDS
	install -D -m 755 $(@D)/makedevs $(TARGET_DIR)/usr/sbin/makedevs
endef

define MAKEDEVS_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/sbin/makedevs
endef


define HOST_MAKEDEVS_BUILD_CMDS
	$(HOSTCC) $(HOST_CFLAGS) $(HOST_LDFLAGS) \
		package/makedevs/makedevs.c -o $(@D)/makedevs
endef

define HOST_MAKEDEVS_INSTALL_CMDS
	install -D -m 755 $(@D)/makedevs $(HOST_DIR)/usr/bin/makedevs
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
