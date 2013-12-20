################################################################################
#
# cryptodev
#
################################################################################

CRYPTODEV_SOURCE =
CRYPTODEV_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_CRYPTODEV))

ifeq ($(CRYPTODEV_DEPENDENCIES),)
define CRYPTODEV_CONFIGURE_CMDS
	echo "No CRYPTODEV implementation defined. Configuration error"
	exit 1
endef
endif

$(eval $(generic-package))
