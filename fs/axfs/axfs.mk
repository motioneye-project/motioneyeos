################################################################################
#
# Build the axfs root filesystem image
#
################################################################################

ROOTFS_AXFS_DEPENDENCIES = host-axfsutils

define ROOTFS_AXFS_CMD
	$(HOST_DIR)/bin/mkfs.axfs -s -a $(TARGET_DIR) $@
endef

$(eval $(call ROOTFS_TARGET,axfs))
