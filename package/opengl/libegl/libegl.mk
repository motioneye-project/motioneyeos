################################################################################
#
# libegl
#
################################################################################

LIBEGL_SOURCE =
LIBEGL_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENGL_EGL))

ifeq ($(LIBEGL_DEPENDENCIES),)
define LIBEGL_CONFIGURE_CMDS
	echo "No libEGL implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
