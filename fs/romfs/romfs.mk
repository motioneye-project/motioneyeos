################################################################################
#
# Build the romfs root filesystem image
#
################################################################################

ROOTFS_ROMFS_DEPENDENCIES = host-genromfs

define ROOTFS_ROMFS_CMD
	$(HOST_DIR)/bin/genromfs -d $(TARGET_DIR) -f $@
endef

$(eval $(call ROOTFS_TARGET,romfs))
