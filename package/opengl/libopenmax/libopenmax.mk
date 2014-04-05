################################################################################
#
# libopenmax
#
################################################################################

LIBOPENMAX_SOURCE =
LIBOPENMAX_DEPENDENCIES = $(call qstrip,$(BR2_PACKAGE_PROVIDES_LIBOPENMAX))

ifeq ($(BR2_PACKAGE_HAS_LIBOPENMAX),y)
ifeq ($(LIBOPENMAX_DEPENDENCIES),)
$(error No libopenmax implementation selected. Configuration error.)
endif
endif

$(eval $(generic-package))
