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

ifeq ($(BR2_PACKAGE_SKELETON_CUSTOM),y)
SKELETON_DEPENDENCIES = skeleton-custom
else
SKELETON_DEPENDENCIES = skeleton-common
endif

$(eval $(generic-package))
