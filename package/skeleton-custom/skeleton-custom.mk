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

# The skeleton also handles the merged /usr case in the sysroot
SKELETON_CUSTOM_INSTALL_STAGING = YES

SKELETON_CUSTOM_PATH = $(call qstrip,$(BR2_ROOTFS_SKELETON_CUSTOM_PATH))

ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM)$(BR_BUILDING),yy)
ifeq ($(SKELETON_CUSTOM_PATH),)
$(error No path specified for the custom skeleton)
endif

ifeq ($(BR2_ROOTFS_MERGED_USR),y)

# Ensure the user has prepared a merged /usr.
#
# Extract the inode numbers for all of those directories. In case any is
# a symlink, we want to get the inode of the pointed-to directory, so we
# append '/.' to be sure we get the target directory. Since the symlinks
# can be anyway (/bin -> /usr/bin or /usr/bin -> /bin), we do that for
# all of them.
#
SKELETON_CUSTOM_LIB_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/lib/.)
SKELETON_CUSTOM_BIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/bin/.)
SKELETON_CUSTOM_SBIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/sbin/.)
SKELETON_CUSTOM_USR_LIB_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/lib/.)
SKELETON_CUSTOM_USR_BIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/bin/.)
SKELETON_CUSTOM_USR_SBIN_INODE = $(shell stat -c '%i' $(SKELETON_CUSTOM_PATH)/usr/sbin/.)

ifneq ($(SKELETON_CUSTOM_LIB_INODE),$(SKELETON_CUSTOM_USR_LIB_INODE))
SKELETON_CUSTOM_NOT_MERGED_USR += /lib
endif
ifneq ($(SKELETON_CUSTOM_BIN_INODE),$(SKELETON_CUSTOM_USR_BIN_INODE))
SKELETON_CUSTOM_NOT_MERGED_USR += /bin
endif
ifneq ($(SKELETON_CUSTOM_SBIN_INODE),$(SKELETON_CUSTOM_USR_SBIN_INODE))
SKELETON_CUSTOM_NOT_MERGED_USR += /sbin
endif

ifneq ($(SKELETON_CUSTOM_NOT_MERGED_USR),)
$(error The custom skeleton in $(SKELETON_CUSTOM_PATH) is not \
	using a merged /usr for the following directories: \
	$(SKELETON_CUSTOM_NOT_MERGED_USR))
endif

endif # merged /usr
endif # ! building

define SKELETON_CUSTOM_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_CUSTOM_PATH),$(TARGET_DIR))
	$(call SYSTEM_USR_SYMLINKS_OR_DIRS,$(TARGET_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(TARGET_DIR))
	$(INSTALL) -m 0644 support/misc/target-dir-warning.txt \
		$(TARGET_DIR_WARNING_FILE)
endef

# For the staging dir, we don't really care about /bin and /sbin.
# But for consistency with the target dir, and to simplify the code,
# we still handle them for the merged or non-merged /usr cases.
# Since the toolchain is not yet available, the staging is not yet
# populated, so we need to create the directories in /usr
define SKELETON_CUSTOM_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/lib
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/bin
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/sbin
	$(call SYSTEM_USR_SYMLINKS_OR_DIRS,$(STAGING_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(STAGING_DIR))
endef

$(eval $(generic-package))
