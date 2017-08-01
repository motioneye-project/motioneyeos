################################################################################
#
# skeleton-common
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_COMMON_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_COMMON_ADD_SKELETON_DEPENDENCY = NO

SKELETON_COMMON_PROVIDES = skeleton

# The skeleton also handles the merged /usr case in the sysroot
SKELETON_COMMON_INSTALL_STAGING = YES

SKELETON_COMMON_PATH = system/skeleton

define SKELETON_COMMON_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_COMMON_PATH),$(TARGET_DIR))
	$(call SYSTEM_USR_SYMLINKS_OR_DIRS,$(TARGET_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(TARGET_DIR))
	$(INSTALL) -m 0644 support/misc/target-dir-warning.txt \
		$(TARGET_DIR_WARNING_FILE)
endef

# We don't care much about what goes in staging, as long as it is
# correctly setup for merged/non-merged /usr. The simplest is to
# fill it in with the content of the skeleton.
define SKELETON_COMMON_INSTALL_STAGING_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_COMMON_PATH),$(STAGING_DIR))
	$(call SYSTEM_USR_SYMLINKS_OR_DIRS,$(STAGING_DIR))
	$(call SYSTEM_LIB_SYMLINK,$(STAGING_DIR))
	$(INSTALL) -d -m 0755 $(STAGING_DIR)/usr/include
endef

SKELETON_COMMON_HOSTNAME = $(call qstrip,$(BR2_TARGET_GENERIC_HOSTNAME))
SKELETON_COMMON_ISSUE = $(call qstrip,$(BR2_TARGET_GENERIC_ISSUE))
SKELETON_COMMON_ROOT_PASSWD = $(call qstrip,$(BR2_TARGET_GENERIC_ROOT_PASSWD))
SKELETON_COMMON_PASSWD_METHOD = $(call qstrip,$(BR2_TARGET_GENERIC_PASSWD_METHOD))
SKELETON_COMMON_BIN_SH = $(call qstrip,$(BR2_SYSTEM_BIN_SH))

ifneq ($(SKELETON_COMMON_HOSTNAME),)
define SKELETON_COMMON_SET_HOSTNAME
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_COMMON_HOSTNAME)" > $(TARGET_DIR)/etc/hostname
	$(SED) '$$a \127.0.1.1\t$(SKELETON_COMMON_HOSTNAME)' \
		-e '/^127.0.1.1/d' $(TARGET_DIR)/etc/hosts
endef
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_SET_HOSTNAME
endif

ifneq ($(SKELETON_COMMON_ISSUE),)
define SKELETON_COMMON_SET_ISSUE
	mkdir -p $(TARGET_DIR)/etc
	echo "$(SKELETON_COMMON_ISSUE)" > $(TARGET_DIR)/etc/issue
endef
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_SET_ISSUE
endif

ifeq ($(BR2_TARGET_ENABLE_ROOT_LOGIN),y)
ifneq ($(filter $$1$$% $$5$$% $$6$$%,$(SKELETON_COMMON_ROOT_PASSWD)),)
SKELETON_COMMON_ROOT_PASSWORD = '$(SKELETON_COMMON_ROOT_PASSWD)'
else ifneq ($(SKELETON_COMMON_ROOT_PASSWD),)
# This variable will only be evaluated in the finalize stage, so we can
# be sure that host-mkpasswd will have already been built by that time.
SKELETON_COMMON_ROOT_PASSWORD = "`$(MKPASSWD) -m "$(SKELETON_COMMON_PASSWD_METHOD)" "$(SKELETON_COMMON_ROOT_PASSWD)"`"
endif
else # !BR2_TARGET_ENABLE_ROOT_LOGIN
SKELETON_COMMON_ROOT_PASSWORD = "*"
endif
define SKELETON_COMMON_SET_ROOT_PASSWD
	$(SED) s,^root:[^:]*:,root:$(SKELETON_COMMON_ROOT_PASSWORD):, $(TARGET_DIR)/etc/shadow
endef
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_SET_ROOT_PASSWD

ifeq ($(BR2_SYSTEM_BIN_SH_NONE),y)
define SKELETON_COMMON_BIN_SH
	rm -f $(TARGET_DIR)/bin/sh
endef
else
ifneq ($(SKELETON_COMMON_BIN_SH),)
define SKELETON_COMMON_BIN_SH
	ln -sf $(SKELETON_COMMON_BIN_SH) $(TARGET_DIR)/bin/sh
endef
endif
endif
SKELETON_COMMON_TARGET_FINALIZE_HOOKS += SKELETON_COMMON_BIN_SH

$(eval $(generic-package))
