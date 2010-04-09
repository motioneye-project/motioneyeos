#############################################################
#
# tar to archive target filesystem
#
#############################################################

TAR_OPTS:=$(BR2_TARGET_ROOTFS_TAR_OPTIONS)

define ROOTFS_TAR_CMD
 tar -c$(TAR_OPTS)f $$@ -C $(TARGET_DIR) .
endef

$(eval $(call ROOTFS_TARGET,tar))
