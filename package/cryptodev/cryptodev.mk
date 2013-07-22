################################################################################
#
# cryptodev
#
################################################################################

CRYPTODEV_SOURCE =

ifeq ($(BR2_PACKAGE_CRYPTODEV_LINUX),y)
CRYPTODEV_DEPENDENCIES += cryptodev-linux
endif

ifeq ($(BR2_PACKAGE_OCF_LINUX),y)
CRYPTODEV_DEPENDENCIES += ocf-linux
endif

ifeq ($(CRYPTODEV_DEPENDENCIES),)
define CRYPTODEV_CONFIGURE_CMDS
	echo "No CRYPTODEV implementation defined. Configuration error"
	exit 1
endef
endif

$(eval $(generic-package))
