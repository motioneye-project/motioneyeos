################################################################################
#
# Build the btrfs root filesystem image
#
################################################################################

BTRFS_SIZE = $(call qstrip,$(BR2_TARGET_ROOTFS_BTRFS_SIZE))
ifeq ($(BR2_TARGET_ROOTFS_BTRFS)-$(BTRFS_SIZE),y-)
$(error BR2_TARGET_ROOTFS_BTRFS_SIZE cannot be empty)
endif

BTRFS_SIZE_NODE = $(call qstrip,$(BR2_TARGET_ROOTFS_BTRFS_SIZE_NODE))
BTRFS_SIZE_SECTOR = $(call qstrip,$(BR2_TARGET_ROOTFS_BTRFS_SIZE_SECTOR))
BTRFS_FEATURES = $(call qstrip,$(BR2_TARGET_ROOTFS_BTRFS_FEATURES))
# qstrip results in stripping consecutive spaces into a single one. So the
# variable is not qstrip-ed to preserve the integrity of the string value.
BTRFS_LABEL = $(subst ",,$(BR2_TARGET_ROOTFS_BTRFS_LABEL))
# ")

BTRFS_OPTS = \
	-f \
	-r '$(TARGET_DIR)' \
	-L '$(BTRFS_LABEL)' \
	--byte-count '$(BTRFS_SIZE)' \
	$(if $(BTRFS_SIZE_NODE),--nodesize '$(BTRFS_SIZE_NODE)') \
	$(if $(BTRFS_SIZE_SECTOR),--sectorsize '$(BTRFS_SIZE_SECTOR)') \
	$(if $(BTRFS_FEATURES),--features '$(BTRFS_FEATURES)')

ROOTFS_BTRFS_DEPENDENCIES = host-btrfs-progs

define ROOTFS_BTRFS_CMD
	$(RM) -f $@
	$(HOST_DIR)/bin/mkfs.btrfs $(BTRFS_OPTS) $@
endef

$(eval $(rootfs))
