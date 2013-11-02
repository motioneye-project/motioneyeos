################################################################################
#
# sunxi-mali-prop
#
################################################################################

SUNXI_MALI_PROP_VERSION = e4ced471d576708ac9aa093e41a0f91cf429862b
SUNXI_MALI_PROP_SITE = http://github.com/linux-sunxi/sunxi-mali-proprietary/tarball/$(SUNXI_MALI_PROP_VERSION)

$(eval $(generic-package))
