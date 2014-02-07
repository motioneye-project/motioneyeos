################################################################################
#
# udev
#
################################################################################

UDEV_SOURCE =

ifeq ($(BR2_PACKAGE_EUDEV),y)
UDEV_DEPENDENCIES += eudev
endif

ifeq ($(UDEV_DEPENDENCIES),)
define UDEV_CONFIGURE_CMDS
	echo "No Udev implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
