################################################################################
#
# libgles
#
################################################################################

LIBGLES_SOURCE =
LIBGLES_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_LIBGLES))

ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
ifeq ($(LIBGLES_DEPENDENCIES),)
$(error No libGLES implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
