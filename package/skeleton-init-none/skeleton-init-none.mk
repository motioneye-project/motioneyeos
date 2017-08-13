################################################################################
#
# skeleton-init-none
#
################################################################################

# The skeleton can't depend on the toolchain, since all packages depends on the
# skeleton and the toolchain is a target package, as is skeleton.
# Hence, skeleton would depends on the toolchain and the toolchain would depend
# on skeleton.
SKELETON_INIT_NONE_ADD_TOOLCHAIN_DEPENDENCY = NO
SKELETON_INIT_NONE_ADD_SKELETON_DEPENDENCY = NO

SKELETON_INIT_NONE_DEPENDENCIES = skeleton-init-common

SKELETON_INIT_NONE_PROVIDES = skeleton

$(eval $(generic-package))
