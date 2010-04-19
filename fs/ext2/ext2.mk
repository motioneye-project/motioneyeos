#############################################################
#
# Build the ext2 root filesystem image
#
#############################################################

EXT2_OPTS :=

ifeq ($(BR2_TARGET_ROOTFS_EXT2_SQUASH),y)
EXT2_OPTS += -U
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
EXT2_OPTS += -b $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_INODES)),0)
EXT2_OPTS += -N $(BR2_TARGET_ROOTFS_EXT2_INODES)
endif

ifneq ($(strip $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)),0)
EXT2_OPTS += -m $(BR2_TARGET_ROOTFS_EXT2_RESBLKS)
endif

ROOTFS_EXT2_DEPENDENCIES = host-genext2fs

ifeq ($(strip $(BR2_TARGET_ROOTFS_EXT2_BLOCKS)),0)
GENEXT2_REALSIZE=$(shell LC_ALL=C du -s -c -k $(TARGET_DIR) | grep total | sed -e "s/total//")
GENEXT2_ADDTOROOTSIZE=$(shell if [ $(GENEXT2_REALSIZE) -ge 20000 ]; then echo 16384; else echo 2400; fi)
GENEXT2_SIZE=$(shell expr $(GENEXT2_REALSIZE) + $(GENEXT2_ADDTOROOTSIZE))
GENEXT2_ADDTOINODESIZE=$(shell find $(TARGET_DIR) | wc -l)
GENEXT2_INODES=$(shell expr $(GENEXT2_ADDTOINODESIZE) + 400)
EXT2_OPTS += -b $(GENEXT2_SIZE) -N $(GENEXT2_INODES)
endif

define ROOTFS_EXT2_CMD
	$(HOST_DIR)/usr/bin/genext2fs -d $(TARGET_DIR) $(EXT2_OPTS) $$@
endef

$(eval $(call ROOTFS_TARGET,ext2))