################################################################################
#
# cpio to archive target filesystem
#
################################################################################

ifeq ($(BR2_ROOTFS_DEVICE_CREATION_STATIC),y)

define ROOTFS_CPIO_ADD_INIT
	if [ ! -e $(TARGET_DIR)/init ]; then \
		ln -sf sbin/init $(TARGET_DIR)/init; \
	fi
endef

else
# devtmpfs does not get automounted when initramfs is used.
# Add a pre-init script to mount it before running init
define ROOTFS_CPIO_ADD_INIT
	if [ ! -e $(TARGET_DIR)/init ]; then \
		$(INSTALL) -m 0755 fs/cpio/init $(TARGET_DIR)/init; \
	fi
endef

PACKAGES_PERMISSIONS_TABLE += /dev/console c 622 0 0 5 1 - - -$(sep)

endif # BR2_ROOTFS_DEVICE_CREATION_STATIC

ROOTFS_CPIO_PRE_GEN_HOOKS += ROOTFS_CPIO_ADD_INIT

define ROOTFS_CPIO_CMD
	cd $(TARGET_DIR) && find . | cpio --quiet -o -H newc > $@
endef

ifeq ($(BR2_TARGET_ROOTFS_CPIO_UIMAGE),y)
ROOTFS_CPIO_DEPENDENCIES += host-uboot-tools
define ROOTFS_CPIO_UBOOT_MKIMAGE
	$(MKIMAGE) -A $(MKIMAGE_ARCH) -T ramdisk \
		-C none -d $@$(ROOTFS_CPIO_COMPRESS_EXT) $@.uboot
endef
ROOTFS_CPIO_POST_GEN_HOOKS += ROOTFS_CPIO_UBOOT_MKIMAGE
endif

$(eval $(call ROOTFS_TARGET,cpio))
