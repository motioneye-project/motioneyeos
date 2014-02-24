################################################################################
#
# udev
#
################################################################################

UDEV_SOURCE =
UDEV_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_UDEV))

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
ifeq ($(UDEV_DEPENDENCIES),)
$(error No Udev implementation selected. Configuration error)
endif
endif

$(eval $(generic-package))
