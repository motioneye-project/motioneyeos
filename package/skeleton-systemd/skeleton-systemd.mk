################################################################################
#
# skeleton-systemd
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_SYSTEMD_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_SYSTEMD_ADD_SKELETON_DEPENDENCY = NO

SKELETON_SYSTEMD_DEPENDENCIES = skeleton-common

SKELETON_SYSTEMD_PROVIDES = skeleton

$(eval $(generic-package))
