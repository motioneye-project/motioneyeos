#############################################################
#
# Virtual package for libEGL
#
#############################################################

LIBEGL_SOURCE =

ifeq ($(LIBEGL_DEPENDENCIES),y)
define LIBEGL_CONFIGURE_CMDS
	echo "No libEGL implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
