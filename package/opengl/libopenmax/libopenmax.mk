################################################################################
#
# libopenmax
#
################################################################################

LIBOPENMAX_SOURCE =
LIBOPENMAX_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_OPENMAX))

ifeq ($(BR2_PACKAGE_HAS_OPENMAX),y)
ifeq ($(LIBOPENMAX_DEPENDENCIES),)
$(error No libopenmax implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
