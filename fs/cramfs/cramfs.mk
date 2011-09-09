#############################################################
#
# Build the cramfs root filesystem image
#
#############################################################
ifeq ($(BR2_ENDIAN),"BIG")
CRAMFS_OPTS=-b
else
CRAMFS_OPTS=-l
endif

define ROOTFS_CRAMFS_CMD
 $(HOST_DIR)/usr/bin/mkcramfs -q $(CRAMFS_OPTS) $(TARGET_DIR) $$@
endef

ROOTFS_CRAMFS_DEPENDENCIES = host-cramfs

$(eval $(call ROOTFS_TARGET,cramfs))
