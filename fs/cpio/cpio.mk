#############################################################
#
# cpio to archive target filesystem
#
#############################################################

define ROOTFS_CPIO_INIT_SYMLINK
	rm -f $(TARGET_DIR)/init
	ln -s sbin/init $(TARGET_DIR)/init
endef

ROOTFS_CPIO_PRE_GEN_HOOKS += ROOTFS_CPIO_INIT_SYMLINK

define ROOTFS_CPIO_CMD
	cd $(TARGET_DIR) && find . | cpio --quiet -o -H newc > $$@
endef

$(eval $(call ROOTFS_TARGET,cpio))