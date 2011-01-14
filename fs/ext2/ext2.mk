#############################################################
#
# Build the ext2 root filesystem image
#
#############################################################

EXT2_OPTS :=

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
EXT2_OPTS += -b $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_INODES)),0)
EXT2_OPTS += -N $(BR2_TARGET_ROOTFS_EXT2_INODES)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)),0)
EXT2_OPTS += -m $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)
endif

ROOTFS_EXT2_DEPENDENCIES = host-genext2fs

define ROOTFS_EXT2_CMD
	PATH=$(TARGET_PATH) fs/ext2/genext2fs.sh -d $(TARGET_DIR) $(EXT2_OPTS) $$@
endef

$(eval $(call ROOTFS_TARGET,ext2))
