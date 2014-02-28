################################################################################
#
# libopenvg
#
################################################################################

LIBOPENVG_SOURCE =
LIBOPENVG_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENVG))

ifeq ($(BR2_PACKAGE_HAS_OPENVG),y)
ifeq ($(LIBOPENVG_DEPENDENCIES),)
$(error No libOpenVG implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
