################################################################################
#
# libgles
#
################################################################################

LIBGLES_SOURCE =
LIBGLES_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_ES))

ifeq ($(BR2_PACKAGE_HAS_OPENGL_ES),y)
ifeq ($(LIBGLES_DEPENDENCIES),)
$(error No libGLES implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
