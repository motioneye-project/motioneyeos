################################################################################
#
# sunxi-mali-prop
#
################################################################################

SUNXI_MALI_PROP_VERSION = 1c5063f43cdc9de341c0d63b2e3921cab86c7742
SUNXI_MALI_PROP_SITE = $(call github,linux-sunxi,sunxi-mali-proprietary,$(SUNXI_MALI_PROP_VERSION))

$(eval $(generic-package))
