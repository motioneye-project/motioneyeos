#############################################################
#
# Embed the ubifs image into an ubi one
#
#############################################################

UBI_UBINIZE_OPTS := -m $(BR2_TARGET_ROOTFS_UBIFS_MINIOSIZE)
UBI_UBINIZE_OPTS += -p $(BR2_TARGET_ROOTFS_UBI_PEBSIZE)
ifneq ($(BR2_TARGET_ROOTFS_UBI_SUBSIZE),0)
UBI_UBINIZE_OPTS += -s $(BR2_TARGET_ROOTFS_UBI_SUBSIZE)
endif

ROOTFS_UBI_DEPENDENCIES = rootfs-ubifs

define ROOTFS_UBI_CMD
	cp fs/ubifs/ubinize.cfg . ;\
	echo "image=$$@fs" \
		>> ./ubinize.cfg ;\
	$(HOST_DIR)/usr/sbin/ubinize -o $$@ $(UBI_UBINIZE_OPTS) ubinize.cfg ;\
	rm ubinize.cfg
endef

$(eval $(call ROOTFS_TARGET,ubi))
