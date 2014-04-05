################################################################################
#
# libopenvg
#
################################################################################

LIBOPENVG_SOURCE =
LIBOPENVG_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_LIBOPENVG))

ifeq ($(BR2_PACKAGE_HAS_LIBOPENVG),y)
ifeq ($(LIBOPENVG_DEPENDENCIES),)
$(error No libOpenVG implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
