################################################################################
#
# Build the squashfs root filesystem image
#
################################################################################

ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS4),y)
ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs

ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS4_LZO),y)
ROOTFS_SQUASHFS_ARGS += -comp lzo
else
ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS4_LZMA),y)
ROOTFS_SQUASHFS_ARGS += -comp lzma
else
ifeq ($(BR2_TARGET_ROOTFS_SQUASHFS4_XZ),y)
ROOTFS_SQUASHFS_ARGS += -comp xz
else
ROOTFS_SQUASHFS_ARGS += -comp gzip
endif
endif
endif

else
ROOTFS_SQUASHFS_DEPENDENCIES = host-squashfs3

ifeq ($(BR2_ENDIAN),"BIG")
ROOTFS_SQUASHFS_ARGS=-be
else
ROOTFS_SQUASHFS_ARGS=-le
endif

endif

define ROOTFS_SQUASHFS_CMD
	$(HOST_DIR)/usr/bin/mksquashfs $(TARGET_DIR) $@ -noappend \
		$(ROOTFS_SQUASHFS_ARGS) && \
	chmod 0644 $@
endef

$(eval $(call ROOTFS_TARGET,squashfs))
