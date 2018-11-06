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
F2FS_COLD_FILES = $(call qstrip,$(BR2_TARGET_ROOTFS_F2FS_COLD_FILES))
F2FS_HOT_FILES = $(call qstrip,$(BR2_TARGET_ROOTFS_F2FS_HOT_FILES))

ifeq ($(BR2_TARGET_ROOTFS_F2FS_DISCARD),y)
F2FS_DISCARD = 1
else
F2FS_DISCARD = 0
endif

F2FS_FEATURES = $(call qstrip,$(BR2_TARGET_ROOTFS_F2FS_FEATURES))

F2FS_OPTS = \
	-f \
	-l "$(F2FS_LABEL)" \
	-t $(F2FS_DISCARD) \
	-o $(BR2_TARGET_ROOTFS_F2FS_OVERPROVISION) \
	$(if $(F2FS_COLD_FILES),-e "$(F2FS_COLD_FILES)") \
	$(if $(F2FS_HOT_FILES),-E "$(F2FS_HOT_FILES)") \
	$(if $(F2FS_FEATURES),-O "$(F2FS_FEATURES)")

ROOTFS_F2FS_DEPENDENCIES = host-f2fs-tools

define ROOTFS_F2FS_CMD
	$(RM) -f $@
	truncate -s $(F2FS_SIZE) $@
	$(HOST_DIR)/sbin/mkfs.f2fs $(F2FS_OPTS) $@
	$(HOST_DIR)/sbin/sload.f2fs -f $(TARGET_DIR) $@
endef

$(eval $(rootfs))
