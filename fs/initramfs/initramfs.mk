#############################################################
#
# Make a initramfs_list file to be used by gen_init_cpio
# gen_init_cpio is part of the 2.6 linux kernels to build an
# initial ramdisk filesystem based on cpio
#
#############################################################

ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)

define ROOTFS_INITRAMFS_ADD_INIT
	if [ ! -e $(TARGET_DIR)/init ]; then \
		ln -sf sbin/init $(TARGET_DIR)/init; \
	fi
endef

else
# devtmpfs does not get automounted when initramfs is used.
# Add a pre-init script to mount it before running init
define ROOTFS_INITRAMFS_ADD_INIT
	if [ ! -e $(TARGET_DIR)/init ]; then \
		$(INSTALL) -m 0755 fs/initramfs/init $(TARGET_DIR)/init; \
	fi
endef

endif # BR2_ROOTFS_DEVICE_CREATION_STATIC

ROOTFS_INITRAMFS_PRE_GEN_HOOKS += ROOTFS_INITRAMFS_ADD_INIT

define ROOTFS_INITRAMFS_CMD
	$(SHELL) fs/initramfs/gen_initramfs_list.sh -u 0 -g 0 $(TARGET_DIR) > $$@
endef

ROOTFS_INITRAMFS_POST_TARGETS += linux26-rebuild-with-initramfs

$(eval $(call ROOTFS_TARGET,initramfs))
