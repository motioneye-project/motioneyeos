################################################################################
#
# Build the ext2 root filesystem image
#
################################################################################

EXT2_OPTS = -G $(BR2_TARGET_ROOTFS_EXT2_GEN) -R $(BR2_TARGET_ROOTFS_EXT2_REV)

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
EXT2_OPTS += -b $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_INODES)),0)
EXT2_OPTS += -i $(BR2_TARGET_ROOTFS_EXT2_INODES)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)),0)
EXT2_OPTS += -r $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)
endif

ROOTFS_EXT2_DEPENDENCIES = host-mke2img

define ROOTFS_EXT2_CMD
	PATH=$(BR_PATH) mke2img -d $(TARGET_DIR) $(EXT2_OPTS) -o $@
endef

rootfs-ext2-symlink:
	ln -sf rootfs.ext2$(ROOTFS_EXT2_COMPRESS_EXT) $(BINARIES_DIR)/rootfs.ext$(BR2_TARGET_ROOTFS_EXT2_GEN)$(ROOTFS_EXT2_COMPRESS_EXT)

ifneq ($(BR2_TARGET_ROOTFS_EXT2_GEN),2)
ROOTFS_EXT2_POST_TARGETS += rootfs-ext2-symlink
endif

$(eval $(call ROOTFS_TARGET,ext2))
