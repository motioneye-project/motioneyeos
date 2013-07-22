################################################################################
#
# libopenmax
#
################################################################################

LIBOPENMAX_SOURCE =

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBOPENMAX_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_PACKAGE_BELLAGIO),y)
LIBOPENMAX_DEPENDENCIES += bellagio
endif

ifeq ($(LIBOPENMAX_DEPENDENCIES),)
define LIBOPENMAX_CONFIGURE_CMDS
	echo "No libopenmax implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
