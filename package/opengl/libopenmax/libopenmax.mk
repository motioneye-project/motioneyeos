################################################################################
#
# libopenmax
#
################################################################################

LIBOPENMAX_SOURCE =
LIBOPENMAX_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENMAX))

ifeq ($(LIBOPENMAX_DEPENDENCIES),)
define LIBOPENMAX_CONFIGURE_CMDS
	echo "No libopenmax implementation selected. Configuration error."
	exit 1
endef
endif

$(eval $(generic-package))
