################################################################################
#
# Build a kernel with an integrated initial ramdisk
# filesystem based on cpio.
#
################################################################################

ROOTFS_INITRAMFS_DEPENDENCIES += rootfs-cpio

ROOTFS_INITRAMFS_POST_TARGETS += linux-rebuild-with-initramfs


# The generic fs infrastructure isn't very useful here.

rootfs-initramfs: $(ROOTFS_INITRAMFS_DEPENDENCIES) $(ROOTFS_INITRAMFS_POST_TARGETS)

rootfs-initramfs-show-depends:
	@echo $(ROOTFS_INITRAMFS_DEPENDENCIES)

ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
TARGETS_ROOTFS += rootfs-initramfs
endif
