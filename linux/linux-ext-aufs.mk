################################################################################
# Linux Aufs extensions
#
# Patch the linux kernel with aufs extension
################################################################################

LINUX_EXTENSIONS += aufs

define AUFS_PREPARE_KERNEL
	if test -d $(@D)/fs/aufs/; then \
		echo "Your kernel already supports AUFS."; \
		exit 1; \
	fi
	$(APPLY_PATCHES) $(@D) $(AUFS_DIR) \
		aufs$(BR2_PACKAGE_AUFS_SERIES)-kbuild.patch \
		aufs$(BR2_PACKAGE_AUFS_SERIES)-base.patch \
		aufs$(BR2_PACKAGE_AUFS_SERIES)-mmap.patch \
		aufs$(BR2_PACKAGE_AUFS_SERIES)-standalone.patch
	cp -r $(AUFS_DIR)/fs/aufs/ $(@D)/fs/
	cp $(AUFS_DIR)/include/uapi/linux/aufs_type.h $(@D)/include/uapi/linux/
endef
