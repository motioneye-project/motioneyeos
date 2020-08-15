################################################################################
#
# skeleton-init-openrc
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_INIT_OPENRC_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_INIT_OPENRC_ADD_SKELETON_DEPENDENCY = NO

SKELETON_INIT_OPENRC_DEPENDENCIES = skeleton-init-common

SKELETON_INIT_OPENRC_PROVIDES = skeleton

ifeq ($(BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW),y)
# Comment /dev/root entry in fstab. When openrc does not find fstab entry for
# "/", it will try to remount "/" as "rw".
define SKELETON_INIT_OPENRC_ROOT_RO_OR_RW
	$(SED) '\:^/dev/root[[:blank:]]:s/^/# /' $(TARGET_DIR)/etc/fstab
endef
else
# Uncomment /dev/root entry in fstab which has "ro" option so openrc notices
# it and doesn't remount root to rw.
define SKELETON_INIT_OPENRC_ROOT_RO_OR_RW
	$(SED) '\:^#[[:blank:]]*/dev/root[[:blank:]]:s/^# //' $(TARGET_DIR)/etc/fstab
endef
endif # BR2_TARGET_GENERIC_REMOUNT_ROOTFS_RW

define SKELETON_INIT_OPENRC_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_INIT_OPENRC_PKGDIR)/skeleton,$(TARGET_DIR))
	$(SKELETON_INIT_OPENRC_ROOT_RO_OR_RW)
endef

$(eval $(generic-package))
