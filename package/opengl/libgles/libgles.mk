################################################################################
#
# libgles
#
################################################################################

LIBGLES_SOURCE =

ifeq ($(BR2_PACKAGE_RPI_USERLAND),y)
LIBGLES_DEPENDENCIES += rpi-userland
endif

ifeq ($(BR2_PACKAGE_TI_GFX),y)
LIBGLES_DEPENDENCIES += ti-gfx
endif

ifeq ($(BR2_PACKAGE_SUNXI_MALI),y)
LIBGLES_DEPENDENCIES += sunxi-mali
endif

ifeq ($(LIBGLES_DEPENDENCIES),)
define LIBGLES_CONFIGURE_CMDS
	echo "No libGLES implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
