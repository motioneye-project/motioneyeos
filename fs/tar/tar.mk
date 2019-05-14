################################################################################
#
# tar to archive target filesystem
#
################################################################################

TAR_OPTS := $(call qstrip,$(BR2_TARGET_ROOTFS_TAR_OPTIONS))

ROOTFS_TAR_DEPENDENCIES = $(BR2_TAR_HOST_DEPENDENCY)

define ROOTFS_TAR_CMD
	(cd $(TARGET_DIR); find -print0 | LC_ALL=C sort -z | \
		tar $(TAR_OPTS) -cf $@ --null --xattrs-include='*' --no-recursion -T - --numeric-owner)
endef

$(eval $(rootfs))
