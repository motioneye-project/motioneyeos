################################################################################
#
# libgles
#
################################################################################

LIBGLES_SOURCE =
LIBGLES_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_ES))

ifeq ($(LIBGLES_DEPENDENCIES),)
define LIBGLES_CONFIGURE_CMDS
	echo "No libGLES implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
