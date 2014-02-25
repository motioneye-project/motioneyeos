################################################################################
#
# powervr
#
################################################################################

POWERVR_SOURCE =
POWERVR_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_POWERVR))

ifeq ($(BR2_PACKAGE_HAS_POWERVR),y)
ifeq ($(POWERVR_DEPENDENCIES),)
$(error No PowerVR implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
