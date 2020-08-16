################################################################################
#
# Build the EROFS root filesystem image
#
################################################################################

ROOTFS_EROFS_DEPENDENCIES = host-erofs-utils

ifeq ($(BR2_TARGET_ROOTFS_EROFS_LZ4HC),y)
ROOTFS_EROFS_ARGS += -zlz4hc
endif

define ROOTFS_EROFS_CMD
	$(HOST_DIR)/bin/mkfs.erofs $(ROOTFS_EROFS_ARGS) $@ $(TARGET_DIR)
endef

$(eval $(rootfs))
