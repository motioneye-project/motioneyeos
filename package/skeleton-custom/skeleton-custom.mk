################################################################################
#
# skeleton-custom
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_CUSTOM_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_CUSTOM_ADD_SKELETON_DEPENDENCY = NO

SKELETON_CUSTOM_PROVIDES = skeleton

SKELETON_CUSTOM_INSTALL_STAGING = YES

SKELETON_CUSTOM_PATH = $(call qstrip,$(BR2_ROOTFS_SKELETON_CUSTOM_PATH))

ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM)$(BR_BUILDING),yy)
ifeq ($(SKELETON_CUSTOM_PATH),)
$(error No path specified for the custom skeleton)
endif
endif

# Extract the inode numbers for all of those directories. In case any is
# a symlink, we want to get the inode of the pointed-to directory, so we
# append '/.' to be sure we get the target directory. Since the symlinks
# can be anyway (/bin -> /usr/bin or /usr/bin -> /bin), we do that for
# all of them.
#
SKELETON_CUSTOM_LIB_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/lib/. 2>/dev/null)
SKELETON_CUSTOM_BIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/bin/. 2>/dev/null)
SKELETON_CUSTOM_SBIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/sbin/. 2>/dev/null)
SKELETON_CUSTOM_USR_LIB_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/lib/. 2>/dev/null)
SKELETON_CUSTOM_USR_BIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/bin/. 2>/dev/null)
SKELETON_CUSTOM_USR_SBIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/sbin/. 2>/dev/null)

# Ensure that the custom skeleton has /lib, /bin and /sbin, and their
# /usr counterparts
ifeq ($(SKELETON_CUSTOM_LIB_INODE),)
SKELETON_CUSTOM_MISSING_DIRS += /lib
endif
ifeq ($(SKELETON_CUSTOM_USR_LIB_INODE),)
SKELETON_CUSTOM_MISSING_DIRS += /usr/lib
endif
ifeq ($(SKELETON_CUSTOM_BIN_INODE),)
SKELETON_CUSTOM_MISSING_DIRS += /bin
endif
ifeq ($(SKELETON_CUSTOM_USR_BIN_INODE),)
SKELETON_CUSTOM_MISSING_DIRS += /usr/bin
endif
ifeq ($(SKELETON_CUSTOM_SBIN_INODE),)
SKELETON_CUSTOM_MISSING_DIRS += /sbin
endif
ifeq ($(SKELETON_CUSTOM_USR_SBIN_INODE),)
SKELETON_CUSTOM_MISSING_DIRS += /usr/sbin
endif

# For a merged /usr, ensure that /lib, /bin and /sbin and their /usr
# counterparts are appropriately setup as symlinks ones to the others.
ifeq ($(BR2_ROOTFS_MERGED_USR),y)

ifneq ($(SKELETON_CUSTOM_LIB_INODE),$(SKELETON_CUSTOM_USR_LIB_INODE))
SKELETON_CUSTOM_NOT_MERGED_USR_DIRS += /lib
endif
ifneq ($(SKELETON_CUSTOM_BIN_INODE),$(SKELETON_CUSTOM_USR_BIN_INODE))
SKELETON_CUSTOM_NOT_MERGED_USR_DIRS += /bin
endif
ifneq ($(SKELETON_CUSTOM_SBIN_INODE),$(SKELETON_CUSTOM_USR_SBIN_INODE))
SKELETON_CUSTOM_NOT_MERGED_USR_DIRS += /sbin
endif

endif # merged /usr

ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM)$(BR_BUILDING),yy)
ifneq ($(SKELETON_CUSTOM_MISSING_DIRS),)
$(error The custom skeleton in $(SKELETON_CUSTOM_PATH) is \
	missing those directories or symlinks: \
	$(SKELETON_CUSTOM_MISSING_DIRS))
endif
ifneq ($(SKELETON_CUSTOM_NOT_MERGED_USR_DIRS),)
$(error The custom skeleton in $(SKELETON_CUSTOM_PATH) is not \
	using a merged /usr for the following directories: \
	$(SKELETON_CUSTOM_NOT_MERGED_USR_DIRS))
endif
endif

# The target-dir-warning file and the lib{32,64} symlinks are the only
# things we customise in the custom skeleton.
define SKELETON_CUSTOM_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_CUSTOM_PATH),$(TARGET_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(TARGET_DIR))
	$(INSTALL) -m 0644 support/misc/target-dir-warning.txt \
		$(TARGET_DIR_WARNING_FILE)
endef

# For the staging dir, we don't really care what we install, but we
# need the /lib and /usr/lib appropriately setup. Since we ensure,
# above, that they are correct in the skeleton, we can simply copy the
# skeleton to staging.
define SKELETON_CUSTOM_INSTALL_STAGING_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_CUSTOM_PATH),$(STAGING_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(STAGING_DIR))
endef

$(eval $(generic-package))
