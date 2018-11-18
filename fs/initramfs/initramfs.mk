################################################################################
#
# Build a kernel with an integrated initial ramdisk filesystem based on cpio.
#
################################################################################

# The generic fs infrastructure isn't very useful here.
#
# The initramfs image does not actually build an image; its only purpose is:
# 1- to ensure rootfs.cpio is generated,
# 2- to then rebuild the kernel with rootfs.cpio as initramfs
#
# Note: ordering of the dependencies is not guaranteed here, but in
# linux/linux.mk, via the linux-rebuild-with-initramfs rule, which depends
# on the rootfs-cpio filesystem rule.
#
# Note: the trick here is that we directly depend on rebuilding the Linux
# kernel image (which itself depends on the rootfs-cpio rule), while we
# advertise that our dependency is on the rootfs-cpio rule, which is
# cleaner in the dependency graph.

rootfs-initramfs: linux-rebuild-with-initramfs

rootfs-initramfs-show-depends:
	@echo rootfs-cpio

.PHONY: rootfs-initramfs rootfs-initramfs-show-depends

ifeq ($(BR2_TARGET_ROOTFS_INITRAMFS),y)
TARGETS_ROOTFS += rootfs-initramfs
endif
