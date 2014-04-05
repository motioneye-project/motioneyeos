################################################################################
#
# libegl
#
################################################################################

LIBEGL_SOURCE =
LIBEGL_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_LIBEGL))

ifeq ($(BR2_PACKAGE_HAS_LIBEGL),y)
ifeq ($(LIBEGL_DEPENDENCIES),)
$(error No libEGL implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
