#############################################################
#
# Virtual package for libOpenVG
#
#############################################################

LIBOPENVG_SOURCE =

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBOPENVG_DEPENDENCIES += rpi-userland
endif

ifeq ($(LIBOPENVG_DEPENDENCIES),y)
define LIBOPENVG_CONFIGURE_CMDS
	echo "No libOpenVG implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
