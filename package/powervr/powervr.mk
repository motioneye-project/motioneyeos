################################################################################
#
# powervr
#
################################################################################

POWERVR_SOURCE =
POWERVR_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_POWERVR))

ifeq ($(POWERVR_DEPENDENCIES),)
define POWERVR_CONFIGURE_CMDS
	echo "No PowerVR implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
