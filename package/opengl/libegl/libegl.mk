################################################################################
#
# libegl
#
################################################################################

LIBEGL_SOURCE =
LIBEGL_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_EGL))

ifeq ($(BR2_PACKAGE_HAS_OPENGL_EGL),y)
ifeq ($(LIBEGL_DEPENDENCIES),)
$(error No libEGL implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
