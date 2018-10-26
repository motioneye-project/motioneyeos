################################################################################
#
# Build the f2fs root filesystem image
#
################################################################################

F2FS_SIZE = $(call qstrip,$(BR2_TARGET_ROOTFS_F2FS_SIZE))
ifeq ($(BR2_TARGET_ROOTFS_F2FS)-$(F2FS_SIZE),y-)
$(error BR2_TARGET_ROOTFS_F2FS_SIZE cannot be empty)
endif

# qstrip results in stripping consecutive spaces into a single one. So the
# variable is not qstrip-ed to preserve the integrity of the string value.
F2FS_LABEL := $(subst ",,$(BR2_TARGET_ROOTFS_F2FS_LABEL))
# ")

F2FS_OPTS = \
	-f \
	-l "$(F2FS_LABEL)"

ROOTFS_F2FS_DEPENDENCIES = host-f2fs-tools

define ROOTFS_F2FS_CMD
	$(RM) -f $@
	truncate -s $(F2FS_SIZE) $@
	$(HOST_DIR)/sbin/mkfs.f2fs $(F2FS_OPTS) $@
	$(HOST_DIR)/sbin/sload.f2fs -f $(TARGET_DIR) $@
endef

$(eval $(rootfs))
