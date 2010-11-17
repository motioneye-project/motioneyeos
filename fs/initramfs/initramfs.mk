#############################################################
#
# Make a initramfs_list file to be used by gen_init_cpio
# gen_init_cpio is part of the 2.6 linux kernels to build an
# initial ramdisk filesystem based on cpio
#
#############################################################

define ROOTFS_INITRAMFS_INIT_SYMLINK
	if [ ! -e $(TARGET_DIR)/init ]; then \
		ln -sf sbin/init $(TARGET_DIR)/init; \
	fi
endef

ROOTFS_INITRAMFS_PRE_GEN_HOOKS += ROOTFS_INITRAMFS_INIT_SYMLINK

define ROOTFS_INITRAMFS_CMD
	$(SHELL) fs/initramfs/gen_initramfs_list.sh -u 0 -g 0 $(TARGET_DIR) > $$@
endef

ROOTFS_INITRAMFS_POST_TARGETS += linux26-rebuild-with-initramfs

$(eval $(call ROOTFS_TARGET,initramfs))
