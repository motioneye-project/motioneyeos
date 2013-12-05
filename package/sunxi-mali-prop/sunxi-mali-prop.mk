################################################################################
#
# sunxi-mali-prop
#
################################################################################

SUNXI_MALI_PROP_VERSION = e4ced471d576708ac9aa093e41a0f91cf429862b
SUNXI_MALI_PROP_SITE = $(call github,linux-sunxi,sunxi-mali-proprietary,$(SUNXI_MALI_PROP_VERSION))

$(eval $(generic-package))
