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

define SKELETON_INIT_OPENRC_INSTALL_TARGET_CMDS
	$(call SYSTEM_RSYNC,$(SKELETON_INIT_OPENRC_PKGDIR)/skeleton,$(TARGET_DIR))
endef

$(eval $(generic-package))
