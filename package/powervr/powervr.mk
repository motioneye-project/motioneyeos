################################################################################
#
# powervr
#
################################################################################

POWERVR_SOURCE =

ifeq ($(BR2_PACKAGE_TI_GFX),y)
POWERVR_DEPENDENCIES += ti-gfx
endif

ifeq ($(POWERVR_DEPENDENCIES),)
define POWERVR_CONFIGURE_CMDS
	echo "No PowerVR implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
