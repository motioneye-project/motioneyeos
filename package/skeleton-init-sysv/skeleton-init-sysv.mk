################################################################################
#
# skeleton-init-sysv
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_INIT_SYSV_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_INIT_SYSV_ADD_SKELETON_DEPENDENCY = NO

SKELETON_INIT_SYSV_DEPENDENCIES = skeleton-init-common

SKELETON_INIT_SYSV_PROVIDES = skeleton

define SKELETON_INIT_SYSV_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_INIT_SYSV_PKGDIR)/skeleton,$(TARGET_DIR))
endef

# enable/disable swapon/off calls depending on availability of the commands
define SKELETON_INIT_SYSV_SWAPON_SWAPOFF_INITTAB
	if [ -x $(TARGET_DIR)/sbin/swapon -a -x $(TARGET_DIR)/sbin/swapoff ]; then \
		$(SED) '/^#.*\/sbin\/swap/s/^#\+[[:blank:]]*//' $(TARGET_DIR)/etc/inittab; \
	else \
		$(SED) '/^[^#].*\/sbin\/swap/s/^/#/' $(TARGET_DIR)/etc/inittab; \
	fi
endef

SKELETON_INIT_SYSV_TARGET_FINALIZE_HOOKS += SKELETON_INIT_SYSV_SWAPON_SWAPOFF_INITTAB

$(eval $(generic-package))
