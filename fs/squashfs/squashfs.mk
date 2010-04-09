#############################################################
#
# Build the squashfs root filesystem image
#
#############################################################

ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs

define ROOTFS_SQUASHFS_CMD
	$(HOST_DIR)/usr/bin/mksquashfs $(TARGET_DIR) $$@ -noappend
endef

$(eval $(call ROOTFS_TARGET,squashfs))