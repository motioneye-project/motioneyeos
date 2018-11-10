################################################################################
#
# Build the compressed loop root filesystem image
#
################################################################################

ROOTFS_CLOOP_DEPENDENCIES = host-cloop host-cdrkit

define ROOTFS_CLOOP_CMD
	$(HOST_DIR)/bin/genisoimage -r $(TARGET_DIR) | \
		$(HOST_DIR)/bin/create_compressed_fs - 65536 > $@
endef

$(eval $(rootfs))
