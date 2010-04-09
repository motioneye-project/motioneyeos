#############################################################
#
# Build the squashfs root filesystem image
#
#############################################################

ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS4),y)
ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs
else
ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs3
endif

define ROOTFS_SQUASHFS_CMD
	$(HOST_DIR)/usr/bin/mksquashfs $(TARGET_DIR) $$@ -noappend
endef

$(eval $(call ROOTFS_TARGET,squashfs))