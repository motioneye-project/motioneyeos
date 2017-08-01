################################################################################
#
# skeleton
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_ADD_SKELETON_DEPENDENCY = NO

# The skeleton also handles the merged /usr case in the sysroot
SKELETON_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM),y)

SKELETON_DEPENDENCIES = skeleton-custom

else # ! custom skeleton

SKELETON_PATH = system/skeleton

define SKELETON_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_PATH),$(TARGET_DIR))
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
define SKELETON_INSTALL_STAGING_CMDS
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/lib
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/bin
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/sbin
	$(call SYSTEM_USR_SYMLINKS_OR_DIRS,$(STAGING_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(STAGING_DIR))
endef

SKELETON_TARGET_GENERIC_HOSTNAME = $(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
SKELETON_TARGET_GENERIC_ISSUE = $(call qstrip,$(BR2_TARGET_GENERIC_ISSUE))
SKELETON_TARGET_GENERIC_ROOT_PASSWD = $(call qstrip,$(BR2_TARGET_GENERIC_ROOT_PASSWD))
SKELETON_TARGET_GENERIC_PASSWD_METHOD = $(call qstrip,$(BR2_TARGET_GENERIC_PASSWD_METHOD))
SKELETON_TARGET_GENERIC_BIN_SH = $(call qstrip,$(BR2_SYSTEM_BIN_SH))

ifneq ($(SKELETON_TARGET_GENERIC_HOSTNAME),)
define SKELETON_SET_HOSTNAME
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_TARGET_GENERIC_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
	$(SED) '$$a \127.0.1.1\t$(SKELETON_TARGET_GENERIC_HOSTNAME)' \
		-e '/^127.0.1.1/d' $(TARGET_DIR)/etc/hosts
endef
TARGET_FINALIZE_HOOKS += SKELETON_SET_HOSTNAME
endif

ifneq ($(SKELETON_TARGET_GENERIC_ISSUE),)
define SKELETON_SET_ISSUE
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_TARGET_GENERIC_ISSUE)" > $(TARGET_DIR)/etc/issue
endef
TARGET_FINALIZE_HOOKS += SKELETON_SET_ISSUE
endif

ifeq ($(BR2_TARGET_ENABLE_ROOT_LOGIN),y)
ifeq ($(SKELETON_TARGET_GENERIC_ROOT_PASSWD),)
SKELETON_ROOT_PASSWORD =
else ifneq ($(filter $$1$$% $$5$$% $$6$$%,$(SKELETON_TARGET_GENERIC_ROOT_PASSWD)),)
SKELETON_ROOT_PASSWORD = '$(SKELETON_TARGET_GENERIC_ROOT_PASSWD)'
else
# This variable will only be evaluated in the finalize stage, so we can
# be sure that host-mkpasswd will have already been built by that time.
SKELETON_ROOT_PASSWORD = "`$(MKPASSWD) -m "$(SKELETON_TARGET_GENERIC_PASSWD_METHOD)" "$(SKELETON_TARGET_GENERIC_ROOT_PASSWD)"`"
endif
else # !BR2_TARGET_ENABLE_ROOT_LOGIN
SKELETON_ROOT_PASSWORD = "*"
endif

define SKELETON_SET_ROOT_PASSWD
	$(SED) s,^root:[^:]*:,root:$(SKELETON_ROOT_PASSWORD):, $(TARGET_DIR)/etc/shadow
endef
TARGET_FINALIZE_HOOKS += SKELETON_SET_ROOT_PASSWD

ifeq ($(BR2_SYSTEM_BIN_SH_NONE),y)
define SKELETON_BIN_SH
	rm -f $(TARGET_DIR)/bin/sh
endef
else
ifneq ($(SKELETON_TARGET_GENERIC_BIN_SH),)
define SKELETON_BIN_SH
	ln -sf $(SKELETON_TARGET_GENERIC_BIN_SH) $(TARGET_DIR)/bin/sh
endef
endif
endif
TARGET_FINALIZE_HOOKS += SKELETON_BIN_SH

endif # BR2_ROOTFS_SKELETON_DEFAULT

$(eval $(generic-package))
