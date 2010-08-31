#############################################################
#
# Build the squashfs root filesystem image
#
#############################################################

ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS4),y)
ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs
else
ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs3

ifeq ($(BR2_ENDIAN),"BIG")
ROOTFS_SQUASHFS_ARGS=-be
else
ROOTFS_SQUASHFS_ARGS=-le
endif

endif

define ROOTFS_SQUASHFS_CMD
	$(HOST_DIR)/usr/bin/mksquashfs $(TARGET_DIR) $$@ -noappend \
		$(ROOTFS_SQUASHFS_ARGS) && \
	chmod 0644 $$@
endef

$(eval $(call ROOTFS_TARGET,squashfs))
