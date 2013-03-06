#############################################################
#
# Virtual package for libOpenVG
#
#############################################################

LIBOPENVG_SOURCE =

ifeq ($(LIBOPENVG_DEPENDENCIES),y)
define LIBOPENVG_CONFIGURE_CMDS
	echo "No libOpenVG implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
